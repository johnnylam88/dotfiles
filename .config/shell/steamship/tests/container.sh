# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

steamship_modload() { . "${STEAMSHIP_ROOT}/modules/${1}.sh"; }

. "${STEAMSHIP_ROOT}/modules/container.sh"

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

STEAMSHIP_CONTAINER_SHOW='true'
STEAMSHIP_CONTAINER_PREFIX='on '
STEAMSHIP_CONTAINER_SUFFIX=' '
STEAMSHIP_CONTAINER_SYMBOL='@'
STEAMSHIP_CONTAINER_COLOR='CYAN'

TESTS=

assert_equal()
{
	if [ "${3}" = "${4}" ]; then
		echo "${0} > ${1} > ${2}: pass"
	else
		echo "${0} > ${1} > ${2}: FAIL"
		echo "    expected: ${4}"
		echo "    got:      ${3}"
	fi
}

TESTS="${TESTS} test1"
test1() {
	steamship_container_env_file='./container.'"$$"
	( echo 'name=foobar'; echo 'a=b' ) > "${steamship_container_env_file}"

	test1_name=${1}
	test1_with_prefix=$(steamship_container -p)
	test1_without_prefix=$(steamship_container)
	test1_with_prefix_expected="on ${STEAMSHIP_CYAN}@foobar${STEAMSHIP_BASE_COLOR} "
	test1_without_prefix_expected="${STEAMSHIP_CYAN}@foobar${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test1_name}" \
		"in container, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"in container, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	rm -f "${steamship_container_env_file}"
	unset steamship_container_env_file
}

TESTS="${TESTS} test2"
test2() {
	steamship_container_env_file='/nonexistent'

	test2_name=${1}
	test2_with_prefix=$(steamship_container -p)
	test2_without_prefix=$(steamship_container)
	test2_with_prefix_expected=
	test2_without_prefix_expected=

	assert_equal "${test2_name}" \
		"no container, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"no container, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset steamship_container_env_file
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done
