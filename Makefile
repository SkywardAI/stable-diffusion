# check if Debian or macOS
ifeq ($(shell uname -s), Darwin)
.PONY: env
env:
	brew install cmake protobuf rust python@3.10 git wget
else ifeq ($(shell uname -s), Linux)
.PONY: env
env:
	sudo apt update && sudo apt install wget git python3 python3-venv ffmpeg libsm6 libxext6 -y
endif

.PONY: webui
webui:
	git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

.PONY: sdmodel
sdmodel:
	cd stable-diffusion-webui/models/Stable-diffusion && wget https://civitai.com/api/download/models/76907 -O ghostmix_v20Bakedvae.safetensors

.PONY: controlnet
controlnet:
	cd stable-diffusion-webui/extensions && git clone https://github.com/Mikubill/sd-webui-controlnet.git

.PONY: ctmodel
ctmodel:
	cd stable-diffusion-webui/extensions/sd-webui-controlnet/models && wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime.pth -O control_v11p_sd15s2_lineart_anime.pth
	cd stable-diffusion-webui/extensions/sd-webui-controlnet/models && wget https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.pth -O control_v11f1e_sd15_tile.pth

ifeq ($(shell uname -s), Darwin)
.PONY: run
run:
	cd stable-diffusion-webui && ./webui.sh --skip-torch-cuda-test --no-half --opt-split-attention-v1 --lowram
else ifeq ($(shell uname -s), Linux)
.PONY: run
run:
	cd stable-diffusion-webui && ./webui.sh --skip-torch-cuda-test --no-half
endif

.PONY: prepare
prepare: env webui controlnet
prepare: sdmodel ctmodel
