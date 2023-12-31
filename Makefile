.PHONY: tag
tag:
	@if [ "$(TAG)" != "" ]; then \
		git tag -f $(TAG); \
		git push -f liveio $(TAG); \
	fi


# @VITE_RELEASE=prod ~/.cargo/bin/daobox-site serve \

serve:
	@VITE_RELEASE=prod RUST_BACKTRACE=1 DAOBOX_LOG=info \
		DAOBOX_SITE_ASSETS=http://localhost:9082/daobox-assets/0.0.1 \
		~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-site serve \
		--dev-dir ./ \
		--listen=0.0.0.0:9081

export-all:
	@DAOBOX_SITE_ASSETS=/assets/daobox-assets/0.0.1 \
		./node_modules/.bin/daobox-site serve \
		--dev-dir ./ \
		--export

package-tpls:
	@~/Coder/yiibox/daobox-server-next/wz-server/target/debug/daobox-site package-tpls \
		--dev-dir ./ \
		--dist-dir ./dist \
		--with-tpls

fe-dev:
	pnpm run dev

fe-build:
	pnpm run build

dist: fe-build export-all copy-daobox-assets 

dist-tpls: fe-build package-tpls

copy-daobox-assets:
	@if [ ! -d dist/assets ]; then mkdir -p dist/assets; fi
	@cp -r public/daobox-assets dist/assets/


web:
	@./node_modules/.bin/daobox-site web \
		--work-dir dist

daobox-assets-server:
	@./node_modules/.bin/daobox-site web \
		--work-dir public --listen 0.0.0.0:9082