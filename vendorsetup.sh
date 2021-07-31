rompath=$(pwd)
vendor_path="vendor/anbox"

function apply-anbox-patches
{

	${vendor_path}/autopatch.sh

}

function install-anbox
{

	${vendor_path}/anbox-halium/scripts/install.sh

}

function run-anbox
{

	${vendor_path}/anbox-halium/scripts/run-container.sh

}

function stop-anbox
{

	${vendor_path}/anbox-halium/scripts/stop-container.sh

}

function check-anbox-kernel-config
{

	${vendor_path}/anbox-halium/scripts/check-kernel-config.sh

}

function anbox-net
{

	${vendor_path}/anbox-halium/scripts/anbox-net.sh

}

function anbox-generate-props
{

	${vendor_path}/anbox-halium/scripts/generate-props.sh

}
