PKG_NAME=`grep -o ' packageAlias \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`
VERSION9=`grep -o ' packageVersionV9 \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`
VERSION10=`grep -o ' packageVersionV10 \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`
VERSION11=`grep -o ' packageVersionV11 \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`

echo "UMB_VERSION: $UMB_VERSION"

NUGET_DIR="dist/nuget-v10/${PKG_NAME}"
PACKAGE_DIR="${NUGET_DIR}/App_Plugins/${PKG_NAME}"

if [[ -d $NUGET_DIR ]]; then
	rm -rf $NUGET_DIR
fi

# Create nuget package structure
mkdir -p $NUGET_DIR/App_Plugins/$PKG_NAME/Lang
mkdir -p $NUGET_DIR/buildTransitive


cp src/*.css $PACKAGE_DIR/
cp src/*.js $PACKAGE_DIR/
cp src/*.html $PACKAGE_DIR/
cp src/lang/*.xml $PACKAGE_DIR/Lang/


# Copy the Value Converter and README to the nuget folder
cp src/v10/*.cs $NUGET_DIR
cp src/v10/*.md $NUGET_DIR

# Transform the package.xml file
# xsltproc --novalid --xinclude --output dist/package/package.xml lib/packager.xslt src/package.xml


# Create .the csproj file
xsltproc --novalid --xinclude --output $NUGET_DIR/$PKG_NAME.csproj lib/packager.xslt src/v10/csproj.xml

# Create the .targets file
xsltproc --novalid --xinclude --output $NUGET_DIR/buildTransitive/$PKG_NAME.targets lib/packager.xslt src/targets.xml

# Create the package.manifest for the nuget package
xsltproc --novalid --xinclude --output $PACKAGE_DIR/package.manifest lib/manifester-unversioned.xslt src/manifest.xml


# Build the ZIP file
# zip -j "dist/${PKG_NAME}-${VERSION}.zip" dist/package/* -x \*.DS_Store

# Build the Nuget package
dotnet pack --output dist $NUGET_DIR/$PKG_NAME.csproj
