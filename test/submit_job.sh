#!/bin/bash

ulimit -S -s unlimited


YYYY=2023
MM=05
DD=01
HH=12

RES=48

EXEC_DIR=../exec/bin/
RESTART_DIR=/scratch2/BMC/gsienkf/Clara.Draper/DA_test_cases/land-IMSproc/restarts/

############# NO CHANGES NEEDED BELOW THIS LINE
source ../env_GDASApp 

export SNOW_OBS_DIR=/scratch2/NCEPDEV/land/data/DA/

if [ -e fims.nml ]; then 
rm fims.nml
fi
if [ -e ${YYYY}${MM}${DD}.${HH}0000.sfc_data.tile1.nc ]; then 
rm ${YYYY}${MM}${DD}.${HH}0000.sfc_data.tile*
fi 
if [ -e calcfIMS.exe ]; then 
rm calcfIMS.exe
fi

DOY=$(date -d "${YYYY}-${MM}-${DD}" +%j)
JDATE=$YYYY$DOY

TSTUB=oro_C${RES}

cat >> fims.nml << EOF
 &fIMS_nml
  idim=$RES, 
  jdim=$RES,
  jdate=$JDATE,
  otype=${TSTUB},
  yyyymmddhh=${YYYY}${MM}${DD}.${HH},
  imsformat=2,
  imsversion=1.3,
  imsres=4km,
  IMS_obs_path="${SNOW_OBS_DIR}/snow_ice_cover/IMS/${YYYY}/",
  IMS_ind_path="${SNOW_OBS_DIR}/snow_ice_cover/IMS/index_files/",
  /
EOF


# stage restarts
for tt in 1 2 3 4 5 6
do 
ln -s ${RESTART_DIR}/${YYYY}${MM}${DD}.${HH}0000.sfc_data.tile${tt}.nc .
done

ln -s ${EXEC_DIR}/calcfIMS.exe .

calcfIMS.exe

