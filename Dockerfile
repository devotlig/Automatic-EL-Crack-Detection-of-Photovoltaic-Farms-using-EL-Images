# 使用NVIDIA提供的CUDA基础镜像
FROM nvidia/cuda:12.0.0-cudnn8-devel-ubuntu20.04

# 设置非交互模式以避免在安装过程中出现提示
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装基本工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    curl \
    git \
    vim \
    ca-certificates \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*


# 安装Python 3.8及相关工具
RUN apt-get update && \
    apt-get install -y python3.8 python3.8-dev python3.8-distutils && \
    if [ -e /usr/bin/python3 ]; then rm /usr/bin/python3; fi && \
    ln -s /usr/bin/python3.8 /usr/bin/python3 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.8 && \
    rm -rf /var/lib/apt/lists/*

# 设置pip使用国内镜像源以加速下载（可选）
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple

# 安装PyTorch（根据CUDA版本选择适合的PyTorch版本）
# 确保 pip 是最新版本
RUN python3 -m pip install --upgrade pip

# 通过 PyTorch 官方提供的方式安装
RUN pip install torch torchvision torchaudio --index-url https://pypi.org/simple


# 安装YOLOv11及其依赖
RUN pip install ultralytics

# 设置工作目录
WORKDIR /workspace

# 复制requirements文件
COPY requirements.txt .

# 安装依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制源代码
COPY src/ ./src
COPY ultralytics/ ./ultralytics
COPY datasets/ ./datasets
COPY weights/ ./weights
COPY tempDir/ ./tempDir

# 默认命令运行应用程序
CMD ["python3", "src/ui.py"]
