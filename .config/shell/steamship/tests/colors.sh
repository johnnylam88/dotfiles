# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

steamship_modload() { . "${STEAMSHIP_ROOT}/modules/${1}.sh"; }

. "${STEAMSHIP_ROOT}/modules/colors.sh"

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

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
	STEAMSHIP_PROMPT_COLOR='WHITE'
	steamship_colors_prompt

	test1_name=${1}
	test1_base_color=${STEAMSHIP_BASE_COLOR}
	test1_base_color_expected=${STEAMSHIP_WHITE}

	assert_equal "${test1_name}" \
		"base color is WHITE" \
		"${test1_base_color}" \
		"${test1_base_color_expected}"

	unset STEAMSHIP_PROMPT_COLOR
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_PROMPT_COLOR='NORMAL'
	steamship_colors_prompt

	test2_name=${1}
	test2_base_color=${STEAMSHIP_BASE_COLOR}
	test2_base_color_expected=${STEAMSHIP_NORMAL}

	assert_equal "${test2_name}" \
		"base color is NORMAL" \
		"${test2_base_color}" \
		"${test2_base_color_expected}"
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done
