
.PHONY: help run

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

state/setup: ## Prepare your environment to execute
	docker compose --profile download up --build -e CLI_ARGS=" --opt-split-attention "
	mkdir -p state/
	touch state/setup

run: state/setup ## Run the web UI
	docker compose --profile auto up --build -d 
	# where [ui] is one of: auto | auto-cpu | hlky | lstein

test: ## Validate the setup is working
	curl localhost:7860

gfpgan: ## Get the GFPGAN model
	mkdir -p gfpgan
	cd gpfgan && wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -O GFPGANv1.3.pth
	# NOTE: download in the right place
	# and put it into the /stable-diffusion-webui/src/gfpgan/experiments/pretrained_models directory.

esrgan: ## Get the ESRGAN model
	# Download RealESRGAN_x4plus.pth and RealESRGAN_x4plus_anime_6B.pth. Put them into the stable-diffusion-webui/src/realesrgan/experiments/pretrained_models directory.
	wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -O RealESRGAN_x4plus.pth
	wget https://github.com/sd-webui/stable-diffusion-webui#gfpgan:~:text=RealESRGAN_x4plus_anime_6B.pth -O RealESRGAN_x4plus_anime_6B.pth 

ldsr: ## Get the ldSR super scaler
	# Download LDSR project.yaml and model last.cpkt. Rename last.ckpt to model.ckpt and place both under stable-diffusion-webui/src/latent-diffusion/experiments/pretrained_models/
	wget https://heibox.uni-heidelberg.de/f/31a76b13ea27482981b4/?dl=1 -O project.yaml -P stable-diffusion-webui/src/latent-diffusion/experiments/pretrained_models/
	wget https://heibox.uni-heidelberg.de/f/578df07c8fc04ffbadf3/?dl=1  -O last.cpkt -P stable-diffusion-webui/src/latent-diffusion/experiments/pretrained_models/

extras: ## Other extras that could be enabled
	@echo "Download gfpgan and add it to the ui with --gfpgan-dir"
	@echo "--esrgan-models-path"
