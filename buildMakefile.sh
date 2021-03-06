#!/bin/bash

#Shashwati Shradha

#Makefile builder
#-------------------------------------------------------------------------

#Count the number of source files in current directory
countSource=0
for eachFile in `find . -name '*.cpp'`;
do
       if [ $eachFile \!= "*.cpp" ] ;
            then countSource=$((countSource + 1))
       fi
done


#If the number of number of sources files is non-zero, count the number of
#main entry points
countMain=0
if [ $countSource -gt 0 ] ;
then for eachFile in *.cpp;
    do
        findMain=$(grep -e 'main\s\{0,\}(.*)' $eachFile)
        if [ "$findMain" \!= "" ] ; then 
            mainFound=$(echo  $eachFile | cut -d '.' -f1)
            countMain=$((countMain + 1));
        fi 
    done
fi


#Display error messages
if [ $countSource -eq 0 ];
    then echo "No source file found"
elif [ $countMain \> 1 ];
 then echo "More than one main entry points was found"   
elif [ $countMain -eq 0 ];
 then echo "No source file with main entry point found"  
fi


#Makefile
{
if [ $countSource -eq 0 ];
     then echo  "SOURCE =  "   
elif [ $countSource -gt 0 ] ;
  then
   count=0;
   for eachFile in `find . -name '*.cpp'`;
    do
       if [ $count -eq 0 ] ;
       then echo "SOURCE = $eachFile \\"
       
       elif [ $count -eq 1 ] ;
       then echo  "         $eachFile \\"
       fi
       count=1;
    done
fi
  
echo -e "\nOBJS = \$(SOURCE:.cpp=.o)"

echo -e "\n#GNU C/C++ Compiler"
echo "GCC = g++"

echo -e "\n# GNU C/C++ Linker"
echo "LINK = g++"

echo -e "\n# Compiler flags"
echo "INC ="
echo "CFLAGS = -Wall -O3 -std=c++11 \$(INC)"
echo "CXXFLAGS = \$(CFLAGS)" 

echo -e "\n# Fill in special libraries needed here"
echo "LIBS ="

echo -e "\n.PHONY: clean"

echo -e "\n# Targets include all, clean, debug, tar"

echo -e "\nall : $mainFound"

echo -e "\n$mainFound: \$(OBJS)"
echo "	\$(LINK) -o \$@ \$^ \$(LIBS)"

echo -e "\nclean:"
echo "	rm -rf *.o *.d core $mainFound"

echo -e "\ndebug: CXXFLAGS = -DDEBUG -g -std=c++11"
echo "debug: $mainFound"

echo -e "\ntar: clean"
echo "	tar zcvf $mainFound.tgz \$(SOURCE) *.h Makefile"

echo -e "\nhelp:"
echo "	@echo \"	make $mainFound  - same as make all\"
	@echo \"	make all   - builds the main target\"
	@echo \"	make       - same as make all\"
	@echo \"	make clean - remove .o .d core $mainFound\"
	@echo \"	make debug - make all with -g and -DDEBUG\"
	@echo \"	make tar   - make a tarball of .cpp and .h files\"
	@echo \"	make help  - this message\""

echo -e "\n-include \$(SOURCE:.cpp=.d)"

echo -e "\n%.d: %.cpp"
echo -e "	@set -e; rm -rf \$@;\$(GCC) -MM \$< \$(CXXFLAGS) > \$@\n\n"

} > Makefile





