
KAMAILIO_VERSION=5.2
KAMAILIO_ROOT_DIR=server-${KAMAILIO_VERSION}
KAMAILIO_TAR=${KAMAILIO_ROOT_DIR}.gz.tar

deps:
	sudo apt-get install gcc g++ flex bison libmysqlclient-dev make autoconf \
	libssl-dev libcurl4-openssl-dev libxml2-dev libpcre3-dev mysql-server lib32ncurses5-dev

src:
	if [ -d ${KAMAILIO_ROOT_DIR} ]; then rm -rf ${KAMAILIO_ROOT_DIR}; fi
	if [ ! -f ${KAMAILIO_TAR} ]; then \
	git clone --depth 1 --no-single-branch https://github.com/kamailio/kamailio ${KAMAILIO_ROOT_DIR}; \
	cd ${KAMAILIO_ROOT_DIR} && git checkout -b ${KAMAILIO_VERSION} origin/${KAMAILIO_VERSION}; \
	cd .. && tar -czvf ${KAMAILIO_TAR} -C ${KAMAILIO_ROOT_DIR} . ; else mkdir ${KAMAILIO_ROOT_DIR} && \
	tar -xvf ${KAMAILIO_TAR} -C ${KAMAILIO_ROOT_DIR}; fi
	

install: deps src
	./build.sh ${KAMAILIO_ROOT_DIR}
