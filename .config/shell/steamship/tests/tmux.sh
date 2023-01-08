# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

. "${STEAMSHIP_ROOT}/modules/tmux.sh"

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

STEAMSHIP_TMUX_SHOW='true'
STEAMSHIP_TMUX_PREFIX='via '
STEAMSHIP_TMUX_SUFFIX=' '
STEAMSHIP_TMUX_SYMBOL='%'
STEAMSHIP_TMUX_COLOR='YELLOW'

TESTS=

# Mock
tmux() { echo 'tmux'; }

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
	TMUX_PANE='0'

	test1_name=${1}
	test1_with_prefix=$(steamship_tmux -p)
	test1_without_prefix=$(steamship_tmux)
	test1_with_prefix_expected="via ${STEAMSHIP_YELLOW}%tmux${STEAMSHIP_BASE_COLOR} "
	test1_without_prefix_expected="${STEAMSHIP_YELLOW}%tmux${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test1_name}" \
		"in tmux, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"in tmux, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset TMUX_PANE
}

TESTS="${TESTS} test2"
test2() {
	[ -z "${TMUX_PANE}" ] || unset TMUX_PANE

	test2_name=${1}
	test2_with_prefix=$(steamship_tmux -p)
	test2_without_prefix=$(steamship_tmux)
	test2_with_prefix_expected=
	test2_without_prefix_expected=

	assert_equal "${test2_name}" \
		"no tmux, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"no tmux, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset steamship_tmux_env_file
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done
