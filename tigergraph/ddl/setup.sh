#!/bin/bash

PARAM1=$1
DATA_PATH=${PARAM1:="/data"}
PARAM2=$2
QUERY_PATH=${PARAM2:="/queries"}
PARAM2=$3
DML_PATH=${PARAM2:="/dml"}


echo "==============================================================================="
echo "Setting up the TigerGraph database"
echo "-------------------------------------------------------------------------------"
echo "DATA_PATH: ${DATA_PATH}"
echo "QUERY_PATH: ${QUERY_PATH}"
echo "==============================================================================="

gsql drop all
gsql create_schema.gsql

gsql --graph ldbc_snb load_static$TG_LOAD_HEADER_STR.gsql
gsql --graph ldbc_snb load_dynamic$TG_LOAD_HEADER_STR.gsql

STATIC_PATH=$DATA_PATH/initial_snapshot/static
DYNAMIC_PATH=$DATA_PATH/initial_snapshot/dynamic

gsql --graph ldbc_snb RUN LOADING JOB load_static USING \
  file_Organisation=\"$STATIC_PATH/Organisation\", \
  file_Place=\"$STATIC_PATH/Place\", \
  file_TagClass=\"$STATIC_PATH/TagClass\", \
  file_TagClass_isSubclassOf_TagClass=\"$STATIC_PATH/TagClass_isSubclassOf_TagClass\", \
  file_Tag=\"$STATIC_PATH/Tag\", \
  file_Tag_hasType_TagClass=\"$STATIC_PATH/Tag_hasType_TagClass\", \
  file_Organisation_isLocatedIn_Place=\"$STATIC_PATH/Organisation_isLocatedIn_Place\", \
  file_Place_isPartOf_Place=\"$STATIC_PATH/Place_isPartOf_Place\"

gsql --graph ldbc_snb RUN LOADING JOB load_dynamic USING \
  file_Comment=\"$DYNAMIC_PATH/Comment\", \
  file_Comment_hasCreator_Person=\"$DYNAMIC_PATH/Comment_hasCreator_Person\", \
  file_Comment_hasTag_Tag=\"$DYNAMIC_PATH/Comment_hasTag_Tag\", \
  file_Comment_isLocatedIn_Country=\"$DYNAMIC_PATH/Comment_isLocatedIn_Country\", \
  file_Comment_replyOf_Comment=\"$DYNAMIC_PATH/Comment_replyOf_Comment\", \
  file_Comment_replyOf_Post=\"$DYNAMIC_PATH/Comment_replyOf_Post\", \
  file_Forum=\"$DYNAMIC_PATH/Forum\", \
  file_Forum_containerOf_Post=\"$DYNAMIC_PATH/Forum_containerOf_Post\", \
  file_Forum_hasMember_Person=\"$DYNAMIC_PATH/Forum_hasMember_Person\", \
  file_Forum_hasModerator_Person=\"$DYNAMIC_PATH/Forum_hasModerator_Person\", \
  file_Forum_hasTag_Tag=\"$DYNAMIC_PATH/Forum_hasTag_Tag\", \
  file_Person=\"$DYNAMIC_PATH/Person\", \
  file_Person_hasInterest_Tag=\"$DYNAMIC_PATH/Person_hasInterest_Tag\", \
  file_Person_isLocatedIn_City=\"$DYNAMIC_PATH/Person_isLocatedIn_City\", \
  file_Person_knows_Person=\"$DYNAMIC_PATH/Person_knows_Person\", \
  file_Person_likes_Comment=\"$DYNAMIC_PATH/Person_likes_Comment\", \
  file_Person_likes_Post=\"$DYNAMIC_PATH/Person_likes_Post\", \
  file_Person_studyAt_University=\"$DYNAMIC_PATH/Person_studyAt_University\", \
  file_Person_workAt_Company=\"$DYNAMIC_PATH/Person_workAt_Company\", \
  file_Post=\"$DYNAMIC_PATH/Post\", \
  file_Post_hasCreator_Person=\"$DYNAMIC_PATH/Post_hasCreator_Person\", \
  file_Post_hasTag_Tag=\"$DYNAMIC_PATH/Post_hasTag_Tag\", \
  file_Post_isLocatedIn_Country=\"$DYNAMIC_PATH/Post_isLocatedIn_Country\"

gsql --graph ldbc_snb PUT ExprFunctions FROM \"$QUERY_PATH/ExprFunctions.hpp\"

gsql --graph ldbc_snb $QUERY_PATH/bi1.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi2.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi3.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi4.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi5.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi6.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi7.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi8.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi9.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi10.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi11.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi12.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi13.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi14.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi15.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi16.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi17.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi18.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi19.gsql
gsql --graph ldbc_snb $QUERY_PATH/bi20.gsql
gsql --graph ldbc_snb $QUERY_PATH/stat.gsql

gsql --graph ldbc_snb $DML_PATH/ins_Vertex$TG_REFRESH_HEADER_STR.gsql
gsql --graph ldbc_snb $DML_PATH/ins_Edge$TG_REFRESH_HEADER_STR.gsql

gsql --graph ldbc_snb $DML_PATH/del_Comment.gsql
gsql --graph ldbc_snb $DML_PATH/del_Forum.gsql
gsql --graph ldbc_snb $DML_PATH/del_Person.gsql
gsql --graph ldbc_snb $DML_PATH/del_Post.gsql
gsql --graph ldbc_snb $DML_PATH/del_Edge.gsql

gsql --graph ldbc_snb 'INSTALL QUERY *'