#!/bin/sh

HELLOWORLD_ROOT=`pwd`/template/blackberry

# make directory qnx and copy all files and directories into it
copy_qnx_folder(){
    if [ -d $PROJECT_DIR/proj.blackberry ]; then
        echo "The '$PROJECT_NAME' project exists, can't override! Please input again!"
        create_qnx_project
        exit
    fi
    mkdir $PROJECT_DIR/proj.blackberry
    echo $HELLOWORLD_ROOT
    for file in `ls -a $HELLOWORLD_ROOT/proj.blackberry | grep -E '\.(project|cproject|xml|png|cpp)' `
    do
        file=$HELLOWORLD_ROOT/proj.blackberry/$file
        if [ -f $file ];then
            #echo $file
            cp $file $PROJECT_DIR/proj.blackberry
        fi
    done
}

copy_cpp_h_from_helloworld(){
    if [ -d $PROJECT_DIR/Classes ]; then
        echo "Classes folder exists, skip copying Classes folder!"
    else
        mkdir $PROJECT_DIR/Classes
        for file in `ls $HELLOWORLD_ROOT/Classes/* | grep -E '.(cpp|h|mk)' `
        do
            if [ -f $file ];then
                #echo $file
                cp $file $PROJECT_DIR/Classes
            fi
        done
    fi
}

# copy resources
copy_resouces(){
    if [ -d $PROJECT_DIR/Resources ]; then
        echo "Resources folder exists, skip copying Resources folder!"
    else
        mkdir $PROJECT_DIR/Resources
        
        for file in $HELLOWORLD_ROOT/Resources/*
        do
            #echo $file
            cp $file $PROJECT_DIR/Resources
        done
    fi
}

# replace string
modify_file_content(){
    # here should use # instead of /, why??
    sed "s#$2#$3#g" $PROJECT_DIR/proj.blackberry/$1 > $PROJECT_DIR/proj.blackberry/tmp.txt
    rm $PROJECT_DIR/proj.blackberry/$1
    mv $PROJECT_DIR/proj.blackberry/tmp.txt $PROJECT_DIR/proj.blackberry/$1
}

create_qnx_project(){
    echo "Please input your project name:"
    read PROJECT_NAME
    PROJECT_DIR=`pwd`/$PROJECT_NAME
    
    # check if PROJECT_DIR is exist
    if [ -d $PROJECT_DIR ]; then
        echo ""
    else
        mkdir $PROJECT_DIR
    fi
    
    copy_qnx_folder
    modify_file_content .project BBTemplateProject $PROJECT_NAME
    modify_file_content .cproject BBTemplateProject $PROJECT_NAME
    modify_file_content bar-descriptor.xml BBTemplateProject $PROJECT_NAME
    modify_file_content .cproject ../../../.. ../../..
    modify_file_content bar-descriptor.xml empty/../../../.. empty/../../..
    copy_cpp_h_from_helloworld
    copy_resouces
    echo "Congratulations, the '$PROJECT_NAME' project have been created successfully, please use QNX IDE to import the project!"
}

create_qnx_project
