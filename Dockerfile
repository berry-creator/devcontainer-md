FROM letsdone/devcontainer-base:0.1.1-all
USER root

ARG USERNAME=dev
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

ENTRYPOINT [ "/bin/zsh" ]