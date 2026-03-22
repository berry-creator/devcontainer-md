FROM letsdone/devcontainer-base:0.1.1-all
USER root

#region Add dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      fonts-noto-cjk fonts-wqy-zenhei fonts-wqy-microhei \
      xfce4 xfce4-goodies x11vnc xvfb novnc websockify supervisor \
    && apt-get autoremove -y && apt-get clean -y
#endregion

ARG USERNAME=dev
USER ${USERNAME}
#region Install Playwright, chromium
RUN source ~/.zshrc && install_nodejs \
    && npm install -g playwright \
    && npx playwright install --with-deps chromium
#endregion

#region supervisor && gui startup script
USER root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-gui.sh /usr/bin/start-gui.sh
#endregion

#region Install Claude CLI if needed
ARG CLAUDE_PREINSTALLED=false
USER ${USERNAME}
RUN if [ "${CLAUDE_PREINSTALLED}" = "true" ]; then \
      echo "==> CLAUDE_PREINSTALLED is set to true, installing Claude CLI..." \
      && source ~/.zshrc \
      && install_claude; \
    fi
#endregion

#region Install Gemini CLI if needed
ARG GEMINI_PREINSTALLED=false
USER ${USERNAME}
RUN if [ "${GEMINI_PREINSTALLED}" = "true" ]; then \
      echo "==> GEMINI_PREINSTALLED is set to true, installing Gemini CLI..." \
      && source ~/.zshrc \
      && install_gemini_cli; \
    fi
#endregion

#region Install Codex CLI if needed
ARG CODEX_PREINSTALLED=false
USER ${USERNAME}
RUN if [ "${CODEX_PREINSTALLED}" = "true" ]; then \
      echo "==> CODEX_PREINSTALLED is set to true, installing Codex CLI..." \
      && source ~/.zshrc \
      && install_codex; \
    fi
#endregion

# Switch to dev user
USER ${USERNAME}
WORKDIR /home/${USERNAME}/workspace

EXPOSE 6080 5900

ENTRYPOINT [ "/bin/zsh" ]