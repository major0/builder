## Helper functions

## error <message>
# displays the supplied <message> on stderr
error()
{
	echo "error: $*" >&2
}

## die <message>
# display the supplied <message> and exit with an error
die()
{
	error "$*"
	exit 1
}

## import <package>
# import a package into the current program space
import()
{
	[ -d "${BUILDER_PKGDIR}/${1}" ] || die "no such package '${1}'"
	[ -f "${BUILDER_PKGDIR}/${1}/Buildrules" ] || die "no rule to build package '${1}'"

	# Set the name so it can be used in the Buildrules
	NAME="${1}"

	# Clear all the pkg variables that we depend on
	VERSION=
	DESCRIPTION=
	SOURCE_URI=
	PATCHES=
	BDEPENDS=
	RDEPENDS=

	. "${BUILDER_PKGDIR}/${NAME}/Buildrules"

	[ "${NAME}" = "${1}" ] || die "Buildrules can not set the package name"
	[ -z "${VERSION}" ] && die "missing version in '${NAME}'"
	[ -z "${DESCRIPTION}" ] && die "missing description in '${NAME}'"

	if [ ! -d "${BUILDER_PKGDIR}/${NAME}/source" ]; then
		if [ -z "${SOURCE_URI}" ]; then
			die "SOURCE_URI undefined and no source directory in '${NAME}'"
		fi
	fi

	D="${BUILDER_PKGDIR}/${NAME}/install"
	S="${BUILDER_PKGDIR}/${NAME}/build/${NAME}-${VERSION}"
	F="${BUILDER_PKGDIR}/${NAME}/files"
	L="${BUILDER_PKGDIR}/${NAME}/log"
}
