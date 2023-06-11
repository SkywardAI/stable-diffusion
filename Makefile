.PONY: env
env:
	sudo apt update && sudo apt install wget git python3 python3-venv ffmpeg libsm6 libxext6 -y

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

.PONY: run
run:
	cd stable-diffusion-webui && ./webui.sh --skip-torch-cuda-test --no-half

.PONY: prepare
prepare: env webui controlnet
prepare: sdmodel ctmodel