name=voms-admin-server
tag=3.x

# the Github repo 
git=git://github.com/italiangrid/voms-admin-server.git

# needed dirs
source_dir=sources
rpmbuild_dir=$(shell pwd)/rpmbuild

# spec file and its src
spec_src=$(name).spec.in
spec=$(name).spec

# determine the pom version and the rpm version
pom_version=$(shell grep "<version>" $(source_dir)/$(name)/pom.xml | head -1 | sed -e 's/<version>//g' -e 's/<\/version>//g' -e "s/[ \t]*//g")
rpm_version=$(shell grep "Version:" $(spec) | sed -e "s/Version://g" -e "s/[ \t]*//g")

# shared maven setting URL
mirror_conf_url=https://raw.github.com/italiangrid/build-settings/master/maven/cnaf-mirror-settings.xml

# name of the mirror settings file as packaged in the  decorated source tarball
mirror_conf_name=mirror-settings.xml

# directory where jar deps will be searched for
libs_dir=/var/lib/$(name)/lib

# name of the jar files which make the dependencies
jar_names=voms-clients bcprov-1.46 bcmail-1.46 canl voms-api-java3 commons-io commons-lang

# maven build options
mvn_settings=-U -s $(mirror_conf_name) -DskipTests

.PHONY: clean rpm

all: rpm

print-info:
	@echo
	@echo
	@echo "Packaging $(name) fetched from $(git) for tag $(tag)."
	@echo "Maven settings: $(mvn_settings)"
	@echo "Jar names: $(jar_names)"
	@echo

prepare-sources: sanity-checks clean
	@mkdir -p $(source_dir)/$(name)
	git clone $(git) $(source_dir)/$(name) 
	@cd $(source_dir)/$(name) && git archive --format=tar --prefix=$(name)/ $(tag) > $(name).tar
	# Maven mirror settings 
	wget $(mirror_conf_url) -O $(source_dir)/$(name)/$(mirror_conf_name)
	@cd $(source_dir) && tar -r -f $(name)/$(name).tar $(name)/$(mirror_conf_name) && gzip $(name)/$(name).tar
	@cp $(source_dir)/$(name)/$(name).tar.gz $(source_dir)/$(name).tar.gz

prepare-spec: prepare-sources
	sed -e 's#@@MVN_SETTINGS@@#$(mvn_settings)#g' \
    	-e 's#@@POM_VERSION@@#$(pom_version)#g' \
		-e 's#@@JAR_NAMES@@#$(jar_names)#g' \
		$(spec_src) > $(spec)

rpm: prepare-spec
	mkdir -p $(rpmbuild_dir)/BUILD \
		$(rpmbuild_dir)/RPMS \
		$(rpmbuild_dir)/SOURCES \
		$(rpmbuild_dir)/SPECS \
		$(rpmbuild_dir)/SRPMS
	cp $(source_dir)/$(name).tar.gz $(rpmbuild_dir)/SOURCES/$(name)-$(rpm_version).tar.gz
	rpmbuild --nodeps -v -ba $(spec) --define "_topdir $(rpmbuild_dir)"

clean:
	rm -rf $(source_dir) $(rpmbuild_dir) $(spec)

sanity-checks:
ifndef tag
	$(error tag is undefined)
endif
