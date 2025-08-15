# 使用 bash 作为其 shell
SHELL := /bin/bash

# --- 变量定义 ---
VENV_DIR = .venv
KERNEL_NAME = Jupyter-Learn-Env
REQUIREMENTS_FILE = requirements.txt

# 特殊声明，用于告诉 make，all 和 setup 是伪目标（phony targets）
.PHONY: all setup create_venv install_deps register_kernel clean

# 默认的 make 命令，会执行 all 目标，而 all 目标又会去执行 setup 目标
all: setup

# setup 任务: 创建虚拟环境，安装依赖，并注册 Jupyter 内核
setup: create_venv install_deps register_kernel

# 创建 Python 虚拟环境
create_venv:
	@echo "--- Creating virtual environment..."
	python -m venv $(VENV_DIR)

# 安装依赖
install_deps:
	@echo "--- Activating virtual environment and installing dependencies..."
	@# 激活虚拟环境并安装依赖
	@# 注意: 此处使用不同的激活命令以兼容不同系统
	@# Windows
	@if [ "$(OS)" == "Windows_NT" ]; then \
	  ./$(VENV_DIR)/Scripts/activate && \
	  python -m pip install --upgrade pip && \
	  python -m pip install -r $(REQUIREMENTS_FILE); \
	else \
	  # Linux and macOS \
	  source $(VENV_DIR)/bin/activate && \
	  python -m pip install --upgrade pip && \
	  python -m pip install -r $(REQUIREMENTS_FILE); \
	fi

# 将虚拟环境注册为 Jupyter 内核
register_kernel:
	@echo "--- Registering Jupyter kernel..."
	@# 在激活的环境中安装 ipykernel 并注册
	@if [ "$(OS)" == "Windows_NT" ]; then \
	  ./$(VENV_DIR)/Scripts/activate && \
	  python -m pip install ipykernel && \
	  python -m ipykernel install --user --name=$(KERNEL_NAME) --display-name="Python ($(KERNEL_NAME))"; \
	else \
	  source $(VENV_DIR)/bin/activate && \
	  python -m pip install ipykernel && \
	  python -m ipykernel install --user --name=$(KERNEL_NAME) --display-name="Python ($(KERNEL_NAME))"; \
	fi

# 清理任务: 删除虚拟环境
clean:
	@echo "--- Cleaning up virtual environment..."
	@if [ -d "$(VENV_DIR)" ]; then \
	  rm -rf "$(VENV_DIR)"; \
	fi
	@echo "--- Virtual environment removed."
