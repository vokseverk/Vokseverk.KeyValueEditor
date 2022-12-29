PKG_NAME=`grep -o ' packageAlias \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`
VERSION=`grep -o ' packageVersion \"\(.*\)\"' src/package.ent | awk '{print $2}' | sed 's/"//g'`

# Create the dist directory if needed
if [[ ! -d dist/package ]]; then
	mkdir -p dist/package
else
	rm dist/package/*.*
fi

if [[ -d dist/nuget/$PKG_NAME ]]; then
	rm -rf dist/nuget/$PKG_NAME
fi

# Create nuget package structure
mkdir -p dist/nuget/$PKG_NAME/App_Plugins/$PKG_NAME
mkdir -p dist/nuget/$PKG_NAME/buildTransitive


# Copy files to package dirs
cp src/*.css dist/package/
cp src/*.js dist/package/
cp src/*.html dist/package/
cp src/lang/*.xml dist/package/

cp src/*.css dist/nuget/$PKG_NAME/App_Plugins/$PKG_NAME/
cp src/*.js dist/nuget/$PKG_NAME/App_Plugins/$PKG_NAME/
cp src/*.html dist/nuget/$PKG_NAME/App_Plugins/$PKG_NAME/
cp src/lang/*.xml dist/nuget/$PKG_NAME/App_Plugins/$PKG_NAME/Lang/


# Copy the Value Converters to the dist/ folder
cp src/*.cs dist/

# Transform the package.xml file
xsltproc --novalid --xinclude --output dist/package/package.xml lib/packager.xslt src/package.xml

# Transform the manifest.xml file
xsltproc --novalid --xinclude --output dist/package/package.manifest lib/manifester.xslt src/manifest.xml


# Create .the csproj file
xsltproc --novalid --xinclude --output dist/nuget/$PKG_NAME/$PKG_NAME.csproj lib/packager.xslt src/csproj.xml

# Create the .targets file
xsltproc --novalid --xinclude --output dist/nuget/$PKG_NAME/buildTransitive/$PKG_NAME.targets lib/packager.xslt src/targets.xml

# Create the package.manifest for the nuget package
xsltproc --novalid --xinclude --output dist/nuget/$PKG_NAME/App_Plugins/$PKG_NAME/package.manifest lib/manifester.xslt src/manifest.xml


# Build the ZIP file
# zip -j "dist/${PKG_NAME}-${VERSION}.zip" dist/package/* -x \*.DS_Store

# Build the Nuget package
dotnet pack --output dist dist/nuget/$PKG_NAME/$PKG_NAME.csproj
