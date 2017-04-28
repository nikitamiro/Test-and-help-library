#--------------------------------------------------------------------------------
#read input file into array

filename = 'test.csv'
graph_data = {}

File.open(filename, 'r').each_line do |line|
  line = line.strip.split ','
  graph_data[line.first.to_s] = line.last.to_s
end

graph_data.each_pair do |x,y|
  puts "#{x} => #{y}"
end

#--------------------------------------------------------------------------------
#Make object and call method

class Foo
    def self.some_class_method
        puts self
    end

    def some_instance_method
        self.class.some_class_method
    end
end

print "Class method: "
Foo.some_class_method

print "Instance method: "
Foo.new.some_instance_method


#--------------------------------------------------------------------------------
#Compiler project

require_relative 'scanner.rb'


$parameterList=Array.new
$masterLocalArray=Array.new
$localvar=Array.new

$tempIfArray=Array.new
$tempFuncArray=Array.new
$maybeFuncArray=Array.new

$labelCount=0
$ifStatementTrue=0
$funcParameterTrue=0
$caseCounter=1
$caseArray=Array.new
$reservedOutputFuncName=Array["printf","scanf","read","write"]

$labelDefArray=Array.new

$jumpTableString="\n\njumpTable:;\nswitch ( JUMP )\n{\ncase 0: exit(0);\n"
$jumpTableStringEnd="default: assert(0);\n}\n"
$jumpTableStringEndPrime="}\n"

$testerFileOutput=File.new("testerFileOutput.c", "w")

class LocalVars
    def init(data)
        @index=$localvar.length
        @data=data 
        #@var="lvar[#{@index}]"
        @var="M[BASE+#{@index}]"
    end

    def returnData()
        return @data
    end  

    def returnVar()
        return @var
    end   

    def returnTok()
        return "tempVar"
    end
end

$globalvar=Array.new
class GlobalVars
end


class Parser

    $outputFile=File.new("outputFile.c", "w")

    #vars tester file
    #$testerVars=File.new("vars.txt", "w")

    $curToken
    #the main method of the parser class which takes the first token
    #from the input token class.
    #as said in the assignment description, meta statements are not parsed
    #but will remain in the program.
    def nextToken()
        $curToken=$calcArray.shift
        if $curToken.returnData==";" || $curToken.returnTok=="metaStatement"
            $genCodeArray<<$curToken
            #$outputFile.puts($curToken.returnData)
        elsif $curToken.returnData=="$$"

        else
            $genCodeArray<<$curToken
            #$outputFile.write($curToken.returnData)
        end
        
        while $curToken.returnTok=="metaStatement"
            #$outputFile.puts($curToken.returnData)
            nextToken
        end
    end

    def nextTokenNoPrint()
        $curToken=$calcArray.shift
        while $curToken.returnTok=="metaStatement"
            #$outputFile.puts($curToken.returnData)
            nextTokenNoPrint
        end
    end

    def whichNext(func)
        if $ifStatementTrue==1
            $tempIfArray<<$curToken
            nextTokenNoPrint
        elsif func=="func"
            $tempFuncArray<<$curToken
            nextTokenNoPrint
        elsif func=="maybefunc"
            $maybeFuncArray<<$curToken
            nextTokenNoPrint
        else
            nextToken  
        end
    end

    def funcGeneration(which)
        @newTokenCalcInt=TokenCalc.new("int lvar[#{$localvar.length}]","localVar")
        @newTokenCalcSemi=TokenCalc.new(";","localVarEnd")
        
        if which=="maybefunc"

            #@current=TokenCalc.new("#{$localvar}          ","x")
            #$genCodeArray<<@current



            #$genCodeArray<<@newTokenCalcInt
            #$genCodeArray<<@newTokenCalcSemi

            @newTop=TokenCalc.new("TOP = BASE + #{$localvar.length+1};\n","topEquals")
            $localvar.clear

            if $maybeFuncArray[0].returnData=="main"

                $maybeFuncArray[0].setData("Labelmain:;")
                @newReturnToken=TokenCalc.new("\n\nLabelmainReturn:;\nJUMP = M[BASE - 1];\nTOP = M[BASE - 3];\nBASE = M[BASE - 4];\ngoto jumpTable;\n\n","returnToken")
                @callReturnTokenFunc=TokenCalc.new("#{$maybeFuncArray[0].returnData.chop.chop}Return;\n","returnToken")
                $genCodeArray<<$maybeFuncArray[0]
                $maybeFuncArray.delete_at(0)
                $maybeFuncArray.delete_at(0)
                $maybeFuncArray.delete_at(0)


                j=0
                $maybeFuncArray.each do |i|
                    j+=1
                    break if i.returnData=="{"
                    $genCodeArray<<i.returnData
                    $maybeFuncArray.delete_at(j)
                end
                #$genCodeArray<<$maybeFuncArray[0]
                $maybeFuncArray.delete_at(0)
                $genCodeArray<<@newTop

                x=$maybeFuncArray.length
                $maybeFuncArray.delete_at(x-1)




##########################################################################################
            
               @newLabelFunArray=Array.new
               @tempStringX=""
               #$testerFileOutput.write("#{@StringCheckY }     :")
                for i in 0..$maybeFuncArray.length-1
                    #$testerFileOutput.write("[#{$tempFuncArray[i].returnData},#{$tempFuncArray[i].returnTok}]")
                    @labelNameForCall=""

                    includeInt=0
                    if $reservedOutputFuncName.include? $maybeFuncArray[i].returnData
                        includeInt=1
                    end

                    if $maybeFuncArray[i].returnTok=="identifier" && includeInt==0
                        @labelNameForCall=$maybeFuncArray[i].returnData
                        if $maybeFuncArray[i+1].returnData=="("
                            @tempStringX<<$maybeFuncArray[i].returnData
                            @tempStringX<<$maybeFuncArray[i+1].returnData
                            $maybeFuncArray[i].setData("")
                            $maybeFuncArray[i+1].setData("")
                            for j in i+2..$maybeFuncArray.length-1
                                if $maybeFuncArray[j].returnData==")"
                                    @tempStringX<<$maybeFuncArray[j].returnData
                                    $maybeFuncArray[j].setData("")
                                    @newLabelFunArray<<@tempStringX
                                    
                                    if $maybeFuncArray[j+1].returnData==";"
                                        $maybeFuncArray[j+1].setData("")
                                    end

                                    break
                                end
                                @tempStringX<<$maybeFuncArray[j].returnData
                                $maybeFuncArray[j].setData("")
                            end
                            $labelCount+=1
                            $maybeFuncArray[i].setData("goto Label#{$labelCount};\n\n")
                            $maybeFuncArray[i+1].setData("Label#{$labelCount}:;\n")
                            
                            newTempArrayForParams=Array.new
                            newTempArrayForParams=@tempStringX.split("")
                            
                            # for i in 0..newTempArrayForParams.length-1
                            #     if newTempArrayForParams[i]!="("
                            #         newTempArrayForParams.delete_at(i)
                            #     else
                            #         break
                            #     end
                            # end
                            @tempStringXprime=""
                            newTempArrayForParams.each do |x|
                                @tempStringXprime<<x
                            end
                            @tempStringXprime=@tempStringXprime[@tempStringXprime.index('(')+1..@tempStringXprime.length-2]
                            finalTempArrayForParams=Array.new
                            finalTempArrayForParams<<@tempStringXprime.split(",")
                            $maybeFuncArray[i+2].setData("#{finalTempArrayForParams[0]}\n")
                            @tempStringX=""
                            @tempStringXprime=""
                            newTempArrayForParams.clear

                            localCounterTop=0
                            finalString=""
                            k=0
                            for j in 0..finalTempArrayForParams.length-1
                                @ts2=finalTempArrayForParams[j].to_s
                                @ts1="M[TOP + #{j}] = #{@ts2[2..-3]};\n"
                                finalString<<@ts1
                                k+=1
                            end
                            $labelCount+=1
                            $maybeFuncArray[i+2].setData("#{finalString}")
                            $maybeFuncArray[i+3].setData("M[TOP + #{k}] = BASE;\nM[TOP + #{k+1}] = TOP;\nM[TOP + #{k+3}] = #{$caseCounter};\nBASE = TOP + #{k+4};\ngoto Label#{@labelNameForCall};\n\n")
                            $labelCount+=1
                            $maybeFuncArray[i+4].setData("Label#{$labelCount}:;")
                            $jumpTableString<<"case #{$caseCounter}: Label#{$labelCount};\n"
                            $caseCounter+=1

                            finalTempArrayForParams.clear
                            @labelNameForCall=""
                        end
                    end  
                end
                $testerFileOutput.write("#{@newLabelFunArray}\n")        


##########################################################################################





                #$maybeFuncArray<<@callReturnTokenFunc
                $maybeFuncArray<<@newReturnToken
                $genCodeArray.concat $maybeFuncArray
                $maybeFuncArray.clear

            else
                @StringCheckY="Label#{$maybeFuncArray[0].returnData}:;"
                $maybeFuncArray[0].setData("Label#{$maybeFuncArray[0].returnData}:;")
                @newReturnTokenFunc=TokenCalc.new("\n\n#{$maybeFuncArray[0].returnData.chop.chop}Return:;\nJUMP = M[BASE - 1];\nTOP = M[BASE - 3];\nBASE = M[BASE - 4];\ngoto jumpTable;\n\n","returnToken")
                @callReturnTokenFunc=TokenCalc.new("#{$maybeFuncArray[0].returnData.chop.chop}Return;\n","returnToken")
                $genCodeArray<<$maybeFuncArray[0]
                $maybeFuncArray.delete_at(0)

                $maybeFuncArray.each do |x| 
                    if x.returnData!=")"
                        $maybeFuncArray.delete_at(0)
                        next
                    else
                        $maybeFuncArray.delete_at(0)
                        $maybeFuncArray.delete_at(0)
                        $maybeFuncArray.delete_at(0)
                        break
                    end
                end

                $genCodeArray<<@newTop
                x=$maybeFuncArray.length
                $maybeFuncArray.delete_at(x-1)

##########################################################################################

               @newLabelFunArray=Array.new
               @tempStringX=""
               #$testerFileOutput.write("#{@StringCheckY }     :")
                for i in 0..$maybeFuncArray.length-1
                    #$testerFileOutput.write("[#{$tempFuncArray[i].returnData},#{$tempFuncArray[i].returnTok}]")
                    @labelNameForCall=""

                    includeInt=0
                    if $reservedOutputFuncName.include? $maybeFuncArray[i].returnData
                        includeInt=1
                    end

                    if $maybeFuncArray[i].returnTok=="identifier" && includeInt==0
                        @labelNameForCall=$maybeFuncArray[i].returnData
                        if $maybeFuncArray[i+1].returnData=="("
                            @tempStringX<<$maybeFuncArray[i].returnData
                            @tempStringX<<$maybeFuncArray[i+1].returnData
                            $maybeFuncArray[i].setData("")
                            $maybeFuncArray[i+1].setData("")
                            for j in i+2..$maybeFuncArray.length-1
                                if $maybeFuncArray[j].returnData==")"
                                    @tempStringX<<$maybeFuncArray[j].returnData
                                    $maybeFuncArray[j].setData("")
                                    @newLabelFunArray<<@tempStringX
                                    
                                    if $maybeFuncArray[j+1].returnData==";"
                                        $maybeFuncArray[j+1].setData("")
                                    end
                                    break
                                end
                                @tempStringX<<$maybeFuncArray[j].returnData
                                $maybeFuncArray[j].setData("")
                            end
                            $labelCount+=1
                            $maybeFuncArray[i].setData("goto Label#{$labelCount};\n\n")
                            $maybeFuncArray[i+1].setData("Label#{$labelCount}:;\n")


                            newTempArrayForParams=Array.new
                            newTempArrayForParams=@tempStringX.split("")
                            
                            # for i in 0..newTempArrayForParams.length-1
                            #     if newTempArrayForParams[i]!="("
                            #         newTempArrayForParams.delete_at(i)
                            #     else
                            #         break
                            #     end
                            # end
                            @tempStringXprime=""
                            newTempArrayForParams.each do |x|
                                @tempStringXprime<<x
                            end
                            @tempStringXprime=@tempStringXprime[@tempStringXprime.index('(')+1..@tempStringXprime.length-2]
                            finalTempArrayForParams=Array.new
                            finalTempArrayForParams<<@tempStringXprime.split(",")
                            $maybeFuncArray[i+2].setData("#{finalTempArrayForParams[0]}\n")
                            @tempStringX=""
                            @tempStringXprime=""
                            newTempArrayForParams.clear

                            localCounterTop=0
                            finalString=""
                            k=0
                            for j in 0..finalTempArrayForParams.length-1
                                @ts2=finalTempArrayForParams[j].to_s
                                @ts1="M[TOP + #{j}] = #{@ts2[2..-3]};\n"
                                finalString<<@ts1
                                k+=1
                            end
                            $maybeFuncArray[i+2].setData("#{finalString}")
                            $maybeFuncArray[i+3].setData("M[TOP + #{k}] = BASE;\nM[TOP + #{k+1}] = TOP;\nM[TOP + #{k+3}] = #{$caseCounter};\nBASE = TOP + #{k+4};\ngoto Label#{@labelNameForCall};\n\n")
                            $labelCount+=1
                            $maybeFuncArray[i+4].setData("Label#{$labelCount}:;")
                            $jumpTableString<<"case #{$caseCounter}: Label#{$labelCount};\n"
                            $caseCounter+=1

                            finalTempArrayForParams.clear
                            @labelNameForCall=""
                        end
                    end  
                end
                $testerFileOutput.write("#{@newLabelFunArray}\n")        


##########################################################################################

                #$maybeFuncArray<<@callReturnTokenFunc
                $maybeFuncArray<<@newReturnTokenFunc
                $genCodeArray.concat $maybeFuncArray
                $maybeFuncArray.clear
            end

            
        elsif which=="func"

            #@current=TokenCalc.new("#{$localvar}          ","x")
            #$genCodeArray<<@current
            
            @newTop=TokenCalc.new("TOP = BASE + #{$localvar.length+1};\n","topEquals")
            x=$genCodeArray.length

            if $genCodeArray[x-1].returnTok=="identifier" 
                $genCodeArray.delete_at(x-1)
                if $genCodeArray[x-2].returnTok=="identifier"
                    $genCodeArray.delete_at(x-2)
                end

                #$genCodeArray<<@newTokenCalcInt
                # $localvar.clear

                # $genCodeArray.concat $tempFuncArray
                # $tempFuncArray.clear
            end

                #@current=TokenCalc.new("#{$localvar}          ","x")
                #$genCodeArray<<@current
                
                #$genCodeArray<<@newTokenCalcInt
                #$genCodeArray<<@newTokenCalcSemi
            @StringCheckY="Label#{$tempFuncArray[0].returnData}:;"

            $tempFuncArray[0].setData("Label#{$tempFuncArray[0].returnData}:;")
            @newReturnTokenFunc=TokenCalc.new("\n\n#{$tempFuncArray[0].returnData.chop.chop}Return:;\nJUMP = M[BASE - 1];\nTOP = M[BASE - 3];\nBASE = M[BASE - 4];\ngoto jumpTable;\n\n","returnToken")
            @callReturnTokenFunc=TokenCalc.new("#{$tempFuncArray[0].returnData.chop.chop}Return;\n","returnToken")
            $genCodeArray<<$tempFuncArray[0]
            $tempFuncArray.delete_at(0)

            $tempFuncArray.each do |x| 
                if x.returnData!="{"
                    $tempFuncArray.delete_at(0)
                    next
                else
                    $tempFuncArray.delete_at(0)
                    $tempFuncArray.delete_at(0)
                    break
                end
            end

            $genCodeArray<<@newTop
            x=$tempFuncArray.length
            $tempFuncArray.delete_at(x-1)

##########################################################################################

               @newLabelFunArray=Array.new
               @tempStringX=""
               #$testerFileOutput.write("#{@StringCheckY }     :")
                for i in 0..$tempFuncArray.length-1
                    #$testerFileOutput.write("[#{$tempFuncArray[i].returnData},#{$tempFuncArray[i].returnTok}]")
                    @labelNameForCall=""

                    includeInt=0
                    if $reservedOutputFuncName.include? $tempFuncArray[i].returnData
                        includeInt=1
                    end

                    if $tempFuncArray[i].returnTok=="identifier" && includeInt==0
                        @labelNameForCall=$tempFuncArray[i].returnData
                        if $tempFuncArray[i+1].returnData=="("
                            @tempStringX<<$tempFuncArray[i].returnData
                            @tempStringX<<$tempFuncArray[i+1].returnData
                            $tempFuncArray[i].setData("")
                            $tempFuncArray[i+1].setData("")
                            for j in i+2..$tempFuncArray.length-1
                                if $tempFuncArray[j].returnData==")"
                                    @tempStringX<<$tempFuncArray[j].returnData
                                    $tempFuncArray[j].setData("")
                                    @newLabelFunArray<<@tempStringX
                                    
                                    if $tempFuncArray[j+1].returnData==";"
                                        $tempFuncArray[j+1].setData("")
                                    end
                                    break
                                end
                                @tempStringX<<$tempFuncArray[j].returnData
                                $tempFuncArray[j].setData("")
                            end
                            $labelCount+=1
                            $tempFuncArray[i].setData("goto Label#{$labelCount};\n\n")
                            $tempFuncArray[i+1].setData("Label#{$labelCount}:;\n")

                            newTempArrayForParams=Array.new
                            newTempArrayForParams=@tempStringX.split("")
                            # for i in 0..newTempArrayForParams.length-1
                            #     if newTempArrayForParams[i]!="("
                            #         newTempArrayForParams.delete_at(i)
                            #     else
                            #         break
                            #     end
                            # end
                            @tempStringXprime=""
                            newTempArrayForParams.each do |x|
                                @tempStringXprime<<x
                            end
                            @tempStringXprime=@tempStringXprime[@tempStringXprime.index('(')+1..@tempStringXprime.length-2]
                            finalTempArrayForParams=Array.new
                            finalTempArrayForParams<<@tempStringXprime.split(",")
                            $tempFuncArray[i+2].setData("#{finalTempArrayForParams[0]}\n")

                            @tempStringX=""
                            @tempStringXprime=""
                            newTempArrayForParams.clear

                            localCounterTop=0
                            finalString=""
                            k=0
                            for j in 0..finalTempArrayForParams.length-1
                                @ts2=finalTempArrayForParams[j].to_s
                                @ts1="M[TOP + #{j}] = #{@ts2[2..-3]};\n"
                                finalString<<@ts1
                                k+=1
                            end
                            $tempFuncArray[i+2].setData("#{finalString}")
                            $tempFuncArray[i+3].setData("M[TOP + #{k}] = BASE;\nM[TOP + #{k+1}] = TOP;\nM[TOP + #{k+3}] = #{$caseCounter};\nBASE = TOP + #{k+4};\ngoto Label#{@labelNameForCall};\n\n")
                            $labelCount+=1
                            $tempFuncArray[i+4].setData("Label#{$labelCount}:;")
                            $jumpTableString<<"case #{$caseCounter}: Label#{$labelCount};\n"
                            $caseCounter+=1

                            finalTempArrayForParams.clear
                            @labelNameForCall=""
                        end
                    end  
                end
                $testerFileOutput.write("#{@newLabelFunArray}\n")        


##########################################################################################

            #$tempFuncArray<<@callReturnTokenFunc
            $tempFuncArray<<@newReturnTokenFunc
            $localvar.clear
            $genCodeArray.concat $tempFuncArray
            $tempFuncArray.clear
            
        end
    end

    def checkLocalVar()
        tempBool=true
        $parameterList.each do |x| 
            if x==$curToken.returnData
                tempBool=false
            end
        end

        if tempBool 
            temp=LocalVars.new
            bool=true
            $localvar.each do |x| #if already exists, assign to previous lvar value
                if x.returnData==$curToken.returnData
                    temp=x
                    bool=false
                end
            end
            if bool #if new assign to new lvar value
                temp.init($curToken.returnData)
                $localvar<<temp
                $curToken.setData(temp.returnVar)
            else
                $curToken.setData(temp.returnVar)
            end
        else

        end
    end

    #method used to add token to the variables array to be counted after parsing is completed.
    def checkVars(x)
        if $vars.include?(x)
            return 1
        else 
            return 0
        end
    end
    #method used to add token to the functions array to be counted after parsing is completed.
    def checkFuncs(x)
        if $funcs.include?(x)
            return 1
        else 
            return 0
        end
    end
    #method used to add token to the statements array to be counted after parsing is completed.
    def checkStates(x)
        if $states.include?(x)
            return 1
        else 
            return 0
        end
    end
    #these 3 arrays will be filled with corresponding tokens for variables, functions and statements.
    $vars=Array.new
    $funcs=Array.new
    $states=Array.new

    def parse()
        #the methdo takes the first token from the array
        #and calls the parsing procedure starting at prgrm
        $curToken=$calcArray.shift
        puts "IN parse: #{$curToken.returnData}"
        while $curToken.returnTok=="metaStatement"
            $genCodeArray<<$curToken
            $curToken=$calcArray.shift
        end

        #@meta1=TokenCalc.new("#include <stdlib.h>\n","meta1")
        @meta2=TokenCalc.new("#include <assert.h>\n","meta2")
        @meta3=TokenCalc.new("#define TOP M[0]\n","meta3")
        @meta4=TokenCalc.new("#define BASE M[1]\n","meta4")
        @meta5=TokenCalc.new("#define JUMP M[2]\n","meta5")
        #@meta6=TokenCalc.new("#define MBASE 3\n","meta6")

        #$genCodeArray<<@meta1
        $genCodeArray<<@meta2
        $genCodeArray<<@meta3
        $genCodeArray<<@meta4
        $genCodeArray<<@meta5
        #$genCodeArray<<@meta6

        @intro1=TokenCalc.new("int M[1000];\n","intro1")
        @intro2=TokenCalc.new("int main(void){\n","intro2")
        @intro3=TokenCalc.new("TOP = 3;\n","intro3")
        @intro4=TokenCalc.new("M[TOP] = 0;\n","intro4")
        @intro5=TokenCalc.new("BASE = TOP + 1;\n","intro5")
        @intro6=TokenCalc.new("goto Labelmain;\n\n","intro6")

        

        $genCodeArray<<@intro1
        $genCodeArray<<@intro2
        $genCodeArray<<@intro3
        $genCodeArray<<@intro4
        $genCodeArray<<@intro5
        $genCodeArray<<@intro6


        prgrm
    end

    #the following functions, going until the end of this class
    #following the LL(1) grammar from the readme.
    #my original grammar was incorrect, resulting in failed attempts in parsing fucntion declarations.
    #my original functions also mis-implemented the empty terminals in declarations. 
    #the new functions now only go into the empty terminal if the next token matches the required token
    #needed by the next function if the current function is yielding an empty terminal.

    #each function makes a put to terminal stating which function the parsing procedure is 
    #currently calling and using what token.
    #each function also yields an abort error to terminal if the current parsing procedure fails 
    #due to an unexpected token. This abort error shows the function and current token that led
    #to the parse error.
    def prgrm()
        puts "IN prgrm: #{$curToken.returnData}"
        metaStatements
        typeName("maybefunc")
        id("maybefunc")
        start

        $genCodeArray.concat $labelDefArray
        @jumpTableStart=TokenCalc.new($jumpTableString,"jumpStart")

        @jumpTableEnd=TokenCalc.new($jumpTableStringEnd,"jumpEnd")
        @jumpTableEndPrime=TokenCalc.new($jumpTableStringEndPrime,"jumpEnd")
        $genCodeArray<<@jumpTableStart
        $genCodeArray<<@jumpTableEnd
        $genCodeArray<<@jumpTableEndPrime

        if $curToken.returnData!="$$"
            abort("ABORT prgrm: #{$curToken.returnData}")
        end
        puts "Parser Passed."
    end

    def start()
        puts "IN start: #{$curToken.returnData}"
        if $curToken.returnData==";"


            $genCodeArray.concat $maybeFuncArray
            $maybeFuncArray.clear

            startDataDecls("maybefunc") 

            puts "STARTING NEW FUNC1: #{$curToken.returnData}"
            funcList
        elsif $curToken.returnData=="("
            startFuncList("maybefunc")
        elsif $curToken.returnData=="$$"

        else 
            abort("ABORT start: #{$curToken.returnData}")
        end
    end

    def startDataDecls(func)
        puts "IN startDataDecls: #{$curToken.returnData}"
        if $curToken.returnData==";"
            whichNext("maybefunc")

            $genCodeArray.concat $maybeFuncArray
            $maybeFuncArray.clear
            
        elsif $curToken.returnData==","
            idListTail
            if $curToken.returnData!=";"
                abort("ABORT startDataDecls: #{$curToken.returnData}")
            end
            nextToken
        elsif $curToken.returnData=="int" || $curToken.returnData=="void"
            funcDeclList
            if $curToken.returnData!=";"
                abort("ABORT startDataDecls: #{$curToken.returnData}")
            end
            nextToken
        else
            abort("ABORT startDataDecls: #{$curToken.returnData}")
        end
    end

    def startFuncList(func)
        puts "IN startFuncList: #{$curToken.returnData}"
        if $curToken.returnData!="("
            abort("ABORT startFuncList: #{$curToken.returnData}")
        end
        whichNext(func)
        parameterList(func)
        if $curToken.returnData!=")"
            abort("ABORT startFuncList: #{$curToken.returnData}")
        end
        whichNext(func)
        funcTail(func)

        #funcGeneration("maybe")#########################################################
        #$genCodeArray.concat $maybeFuncArray
        #$maybeFuncArray.clear

        puts "STARTING NEW FUNC2: #{$curToken.returnData}"
        funcList
    end

    def metaStatements()
        puts "IN metaStatements: #{$curToken.returnData}"
        if $curToken.returnTok=="metaStatement" 
            nextToken
            metaStatements
        elsif $curToken.returnData=="int" || $curToken.returnData=="void"

        else
            abort("ABORT metaStatements: #{$curToken.returnData}")
        end
    end

    def funcList()
        puts "IN funcList: #{$curToken.returnData}"
        if $curToken.returnData=="int" || $curToken.returnData=="void"
            func
            funcList
            #if checkFuncs($curToken.returnData)==0
            #    $funcs<<$curToken.returnData
            #end
        elsif $curToken.returnData=="$$" || $curToken.returnData=="{" || $curToken.returnData==";"
    
        else
            abort("ABORT funcList: #{$curToken.returnData}") 
        end
    end

    def func()
        puts "IN func: #{$curToken.returnData}"
        $masterLocalArray<<$localvar
        #$localvar.clear
        funcDecl("func")
        funcTail("func")

    end

    def funcTail(func)
        puts "IN funcTail: #{$curToken.returnData}"
        if $curToken.returnData==";"
            whichNext(func)

            $genCodeArray.concat $tempFuncArray
            $tempFuncArray.clear
        elsif $curToken.returnData=="{"
            whichNext(func)




            dataDecls(func)
            statements(func)
            if $curToken.returnData!="}"
                abort("ABORT funcTail: #{$curToken.returnData}")
            end
            whichNext(func)

            puts "--FUNCTION END: #{$curToken.returnData}"

            funcGeneration(func)#########################################################
        else
            abort("ABORT funcTail: #{$curToken.returnData}") 
        end
    end

    def funcDecl(func)
        puts "IN funcDecl: #{$curToken.returnData}"
        typeName(func)
        if checkFuncs($curToken.returnData)==0
            $funcs<<$curToken.returnData
        end
        if $curToken.returnTok!="identifier"
            abort("ABORT funcDecl: #{$curToken.returnData}")
        end 


        # if $curToken.returnData=="main"
        #     $curToken.setData("LabelMain:;")
        # else
        #     $labelCount+=1
        #     $curToken.setData("Label#{$labelCount}:;")
        # end
        

        whichNext(func)
        if $curToken.returnData!="("
            abort("ABORT funcDecl: #{$curToken.returnData}")
        end
        whichNext(func)
        parameterList(func)
        if $curToken.returnData!=")"
            abort("ABORT funcDecl: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    def funcDeclList()
        puts "IN funcDeclList: #{$curToken.returnData}"
        if $curToken.returnData=="("
            nextToken
            parameterList("nofunc")
            if $curToken.returnData!=")"
                abort("ABORT funcDeclList: #{$curToken.returnData}")
            end
            nextToken
            funcDeclList
        elsif $curToken.returnData==";"

        else
            abort("ABORT funcDeclList: #{$curToken.returnData}")
        end
    end

    def dataDecls(func)
        puts "IN dataDecls: #{$curToken.returnData}"
        if $curToken.returnData=="int" || $curToken.returnData=="void" #|| $curToken.returnData=="main" 
            typeName(func)
            idList(func)
            if $curToken.returnData!=";"
                abort("ABORT dataDecls: #{$curToken.returnData}")
            end
            whichNext(func)
            dataDecls(func)
        elsif $curToken.returnTok=="identifier" || $curToken.returnTok=="reservedWord"

        else
            abort("ABORT dataDecls: #{$curToken.returnData}")
        end
    end

    def typeName(func)
        puts "IN typeName: #{$curToken.returnData}"
        if $curToken.returnData=="int" || $curToken.returnData=="void" 
            $curToken=$calcArray.shift
            #whichNext(func)
        else
            abort("ABORT typeName: #{$curToken.returnData}")
        end
    end

    def parameterList(func)
        puts "IN parameterList: #{$curToken.returnData}"
        if $curToken.returnData=="void"
            whichNext(func)
        elsif $curToken.returnData=="int"
            nonEmptyList(func)
        elsif $curToken.returnData==")"

        else
            abort("ABORT parameterList: #{$curToken.returnData}")
        end 
    end

    def nonEmptyList(func)
        puts "IN nonEmptyList: #{$curToken.returnData}"
        typeName(func)
        if checkVars($curToken.returnData)==0
            $vars<<$curToken.returnData
            $parameterList<<$curToken.returnData
        end
        if $curToken.returnTok!="identifier"
            abort("ABORT nonEmptyList: #{$curToken.returnData}")
        end
        whichNext(func)
        nonEmptyListTail(func)
    end

    def nonEmptyListTail(func)
        puts "IN nonEmptyListTail: #{$curToken.returnData}"
        if $curToken.returnData=="," 
            whichNext(func)
            nonEmptyList(func)
        elsif $curToken.returnData==")"

        else
            abort("ABORT nonEmptyListTail: #{$curToken.returnData}")
        end
    end    

    def idList(func)
        puts "IN List: #{$curToken.returnData}"
        variableID=id(func)
        if checkVars(variableID)==0
            $vars<<variableID
        end
        idListTail(func)
    end

    def idListTail(func)
        puts "IN idListTail: #{$curToken.returnData}"
        if $curToken.returnData=="," 
            whichNext(func)
            variableID=id(func)
            if checkVars(variableID)==0
                $vars<<variableID
            end
            idListTail(func)
        elsif $curToken.returnData==";"

        else
            abort("ABORT idListTail: #{$curToken.returnData}")
        end
    end

    def id(func)
        puts "IN id: #{$curToken.returnData}"
        

        variableID=$curToken.returnData

        if variableID!="main"
            x=LocalVars.new
            x.init(variableID)
            $localvar<<x
            $curToken.setData(x.returnVar)
        end
        printTemp=$curToken
        if $curToken.returnTok!="identifier" # || $curToken.returnData!="main"
            abort("ABORT id: #{$curToken.returnData}")
        end
    
        whichNext(func)
        if $curToken.returnData=="("
            printTemp.setData(variableID)
        end
        idTail(func)
        return variableID
    end

    def idTail(func)
        puts "IN idTail: #{$curToken.returnData}"
        if $curToken.returnData=="["
            whichNext(func)
            expression(func)
            if $curToken.returnData!="]"
                abort("ABORT idTail: #{$curToken.returnData}")
            end
            whichNext(func)
            if $curToken.returnData==";" && $compileTime!=0
               abort("ABORT. Non compile-time evaluable array size.") 
            else 
               $compileTime=0
            end 

        elsif $curToken.returnData==";" || $curToken.returnData=="," || $curToken.returnData=="=" || $curToken.returnData=="("

        else
            abort("ABORT idTail: #{$curToken.returnData}")
        end
    end

    def expressionList(func)
        puts "IN expressionList: #{$curToken.returnData}"
        if $curToken.returnTok=="identifier" || $curToken.returnTok=="number" || $curToken.returnData=="-" || $curToken.returnData=="("
            nonEmptyExpressionList(func)
        elsif $curToken.returnData==")"

        else
            abort("ABORT expressionList: #{$curToken.returnData}")
        end
    end

    def nonEmptyExpressionList(func)
        puts "IN nonEmptyExpressionList: #{$curToken.returnData}"
        expression(func)
        while $curToken.returnData=="+" || $curToken.returnData=="-" || $curToken.returnData=="*" || $curToken.returnData=="/"
            whichNext(func)
            expression(func)
        end
        nonEmptyExpressionListTail(func)
    end

    def nonEmptyExpressionListTail(func)
        puts "IN nonEmptyExpressionListTail: #{$curToken.returnData}"
        if $curToken.returnData==","
            whichNext(func)
            expression(func)
            while $curToken.returnData=="+" || $curToken.returnData=="-" || $curToken.returnData=="*" || $curToken.returnData=="/"
                whichNext(func)
                expression(func)
            end
        elsif $curToken.returnData==")"

        else
            abort("ABORT nonEmptyExpressionListTail: #{$curToken.returnData}")
        end
    end

    def expression(func)
       puts "IN expression: #{$curToken.returnData}"
       term(func)
       expressionTail(func)
    end

    def expressionTail(func)
        puts "IN expressionTail: #{$curToken.returnData}"
        if $curToken.returnData=="+" || $curToken.returnData=="-"
            addop(func)
            expression(func)
            while $curToken.returnData=="+" || $curToken.returnData=="-" || $curToken.returnData=="*" || $curToken.returnData=="/"
                whichNext(func)
                expression(func)
            end
        elsif $curToken.returnData=="]" || $curToken.returnData=="," || $curToken.returnData==")" || $curToken.returnData==";" || $curToken.returnData=="==" || $curToken.returnData=="!=" || $curToken.returnData==">" || $curToken.returnData==">=" || $curToken.returnData=="<" || $curToken.returnData=="<=" || $curToken.returnData=="&&" || $curToken.returnData=="||"

        else
            abort("ABORT expressionTail: #{$curToken.returnData}")
        end
    end

    def mulop(func)
        puts "IN mulop: #{$curToken.returnData}"
        if $curToken.returnData=="*" || $curToken.returnData=="/"
            whichNext(func)
        else
            abort("ABORT mulop: #{$curToken.returnData}")
        end
    end

    def addop(func)
        puts "IN addop: #{$curToken.returnData}"
        if $curToken.returnData=="+" || $curToken.returnData=="-"
            whichNext(func)
        else
            abort("ABORT addop: #{$curToken.returnData}")
        end
    end

    def term(func)
        puts "IN term: #{$curToken.returnData}"
        factor(func)
        termTail(func)
    end

    def termTail(func)
        puts "IN termTail: #{$curToken.returnData}"
        if $curToken.returnData=="*" || $curToken.returnData=="/"
            mulop(func)
            term(func)
        elsif $curToken.returnData=="+" || $curToken.returnData=="-" || $curToken.returnData=="]" || $curToken.returnData=="," || $curToken.returnData==")" || $curToken.returnData==";" || $curToken.returnData=="==" || $curToken.returnData=="!=" || $curToken.returnData==">" || $curToken.returnData==">=" || $curToken.returnData=="<" || $curToken.returnData=="<=" || $curToken.returnData=="&&" || $curToken.returnData=="||"

        else
            abort("ABORT termTail: #{$curToken.returnData}")
        end
    end

    def factor(func)
        puts "IN factor: #{$curToken.returnData}"
        if $curToken.returnTok=="identifier"
            checkLocalVar
            whichNext(func)
            factorIdTail(func)
        elsif $curToken.returnTok=="number"
            checkLocalVar
            whichNext(func)
        elsif $curToken.returnData=="-"
            whichNext(func)
            if $curToken.returnTok!="number"
                abort("ABORT factor: #{$curToken.returnData}")
            end
            whichNext(func)
        elsif $curToken.returnData=="("
            whichNext(func)
            expression(func)
            if $curToken.returnData!=")"
                abort("ABORT factor: #{$curToken.returnData}")
            end
            whichNext(func)
        else
            abort("ABORT factor: #{$curToken.returnData}")
        end 
    end

    def factorIdTail(func)
        puts "IN factorIdTail: #{$curToken.returnData}"
        if $curToken.returnData=="["
            whichNext(func)
            expression(func)
            if $curToken.returnData!="]"
                abort("ABORT factorIdTail: #{$curToken.returnData}")
            end
            whichNext(func)
        elsif $curToken.returnData=="("
            whichNext(func)
            expressionList(func)
            if $curToken.returnData!=")"
                abort("ABORT factorIdTail: #{$curToken.returnData}")
            end
            whichNext(func)
        elsif $curToken.returnData=="*" || $curToken.returnData=="/" || $curToken.returnData=="+" || $curToken.returnData=="-" || $curToken.returnData=="]" || $curToken.returnData=="," || $curToken.returnData==")" || $curToken.returnData==";" || $curToken.returnData=="==" || $curToken.returnData=="!=" || $curToken.returnData==">" || $curToken.returnData==">=" || $curToken.returnData=="<" || $curToken.returnData=="<=" || $curToken.returnData=="&&" || $curToken.returnData=="||"

        else
            abort("ABORT factorIdTail: #{$curToken.returnData}")
        end   
    end

    $compileTime=0
    def statements(func)
        puts "IN statements: #{$curToken.returnData}"
        if $curToken.returnTok=="identifier" || $curToken.returnData=="if" || $curToken.returnData=="while" || $curToken.returnData=="return" || $curToken.returnData=="break" || $curToken.returnData=="continue" || $curToken.returnData=="printf" || $curToken.returnData=="scanf"
            statement(func) 
            statements(func)
        elsif $curToken.returnData=="}"

        else
            abort("ABORT statements: #{$curToken.returnData}")
        end 
    end

    def statement(func)
        puts "IN statement: #{$curToken.returnData}"
        $states<<$curToken
        if $curToken.returnData=="printf"
            printfFuncCall(func)
        elsif $curToken.returnData=="scanf"
            scanfFuncCall(func)
        elsif $curToken.returnData=="if"
            ifStatement(func)
        elsif $curToken.returnData=="while"
            whileStatement(func)
        elsif $curToken.returnData=="return"
            returnStatement(func)
        elsif $curToken.returnData=="break"
            breakStatement(func)
        elsif $curToken.returnData=="continue"
            continueStatement(func)
        elsif $curToken.returnTok=="identifier"
            variableID=$curToken.returnData
            #if $calcArray[1].returnData=="("
                #printTemp=$curToken
                #whichNext(func)
                #if $curToken.returnData=="("
                    #printTemp.setData(variableID)
                #end
                #generalStatement(func)
            #else
                checkLocalVar
                printTemp=$curToken
                whichNext(func)
                if $curToken.returnData=="("
                    x=$localvar.length
                    $localvar.delete_at(x-1)
                    printTemp.setData(variableID)
                end
                generalStatement(func)
            #end
        else
            abort("ABORT statement: #{$curToken.returnData}")
        end 
    end

    def generalStatement(func)
        puts "IN generalStatement: #{$curToken.returnData}"
        if $curToken.returnData=="[" || $curToken.returnData=="=" || $curToken.returnData==";"
            assignment(func)
        elsif $curToken.returnData=="("
            generalFuncCall(func)
        else
            abort("ABORT generalStatement: #{$curToken.returnData}")
        end
    end

    #original <assignment> grammar from parser hwk4:
    #def assignment()
    #    puts "IN assignment: #{$curToken.returnData}"
    #    idTail
    #    if $curToken.returnData!="="
    #        abort("ABORT assignment: #{$curToken.returnData}")
    #    end
    #    nextToken
    #    expression
    #    if $curToken.returnData!=";"
    #        abort("ABORT assignment: #{$curToken.returnData}")
    #    end
    #    nextToken
    #end
#---------------------------------------------------------------------
#Implementation of new grammar using <assignment>, <operan> and evaluation of <expression>.
#---------------------------------------------------------------------
    $newTemp=""
    $newTempCount=0
    $newTempArray=Array.new

    #method makes new temp variables to be displayed in output file.
    #each new temp variables has 2 operands and is saved in the $newTempArray.
    def newTemp()
        if $newTempCount==1 && ($curToken.returnTok=="identifier" || $curToken.returnTok=="number")
            $newTemp<<$curToken.returnData
            $newTempArray<<$newTemp
            $newTempCount=0
            $newTemp=""
        elsif $curToken.returnTok=="identifier" || $curToken.returnTok=="number"
            $newTemp<<$curToken.returnData
            $newTempCount+=1
        else 
            $newTemp<<$curToken.returnData
        end
    end

    def newTempReset()
        $newTempArray.clear
        $newTemp=""
        $newTempCount=0
    end

    def assignment(func)
        puts "IN assignment: #{$curToken.returnData}"
        idTail(func)
        if $curToken.returnData!="="
            abort("ABORT assignment: #{$curToken.returnData}")
        end
        whichNext(func)
        expression(func)
        assignmentTail(func)
        #writing to vars tester file
        #$testerVars.write($newTempArray)
        puts "#{$newTempArray}"
        newTempReset
        
        
        #if $curToken.returnTok=="identifier" 
        #    nextToken
        #    factorIdTail
        #    assignmentTail
        #elsif $curToken.returnData=="(" 
        #    nextToken
        #    if $curToken.returnTok=="identifier" 
        #        nextToken
        #        factorIdTail
        #        assignmentTail
        #    else
        #        expr
        #        assignmentTail
        #    end
        #    if $curToken.returnData==")"
        #        nextToken
        #    end   
        #else 
        #    expr
        #    assignmentTail
        #end
    end

    def assignmentTail(func)
        puts "IN assignmentTail: #{$curToken.returnData}"
        if $curToken.returnData=="*" || $curToken.returnData=="/" 
            mulop(func)
            expression(func)
            assignmentTail2(func)

            if $curToken.returnData!=";"
                abort("ABORT assignmentTail: #{$curToken.returnData}")
            end
            whichNext(func)
        elsif $curToken.returnData=="+" || $curToken.returnData=="-"
            addop
            expression(func)
            assignmentTail2(func)
            if $curToken.returnData!=";"
                abort("ABORT assignmentTail: #{$curToken.returnData}")
            end
            whichNext(func)
        elsif $curToken.returnData==";"
            whichNext(func)
        elsif $curToken.returnData=="(" || $curToken.returnData==")"

        else
            abort("ABORT assignmentTail: #{$curToken.returnData}")   
        end
    end

    def assignmentTail2(func)
        puts "IN assignmentTail2: #{$curToken.returnData}"
        if $curToken.returnData=="*" || $curToken.returnData=="/" 
            mulop(func)
            expression(func)
            if $curToken.returnData==")"
                whichNext(func)
            end
            assignmentTail2(func)
            #if $curToken.returnData!=";"
            #    abort("ABORT assignmentTail2: #{$curToken.returnData}")
            #end
            #nextToken
        elsif $curToken.returnData=="+" || $curToken.returnData=="-"
            addop
            expression(func)
            if $curToken.returnData==")"
                whichNext(func)
            end
            assignmentTail2(func)

        elsif $curToken.returnData==";"
            
        elsif $curToken.returnData=="(" 

        else
            abort("ABORT assignmentTail2: #{$curToken.returnData}")   
        end
    end
    


#---------------------------------------------------------------------
    def generalFuncCall(func)
        puts "IN generalFuncCall: #{$curToken.returnData}"
        if $curToken.returnData!="("
            abort("ABORT generalFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        expressionList(func)
        if $curToken.returnData!=")"
            abort("ABORT generalFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!=";"
            abort("ABORT generalFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    def printfFuncCall(func)
        puts "IN printfFuncCall: #{$curToken.returnData}"
        if $curToken.returnData!="printf"
            abort("ABORT printfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!="("
            abort("ABORT printfFuncCall ')': #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnTok!="string"
            abort("ABORT printfFuncCall 'string': #{$curToken.returnData}")
        end
        whichNext(func)
        printfFuncCallTail(func)
        if $curToken.returnData!=")"
            abort("ABORT printfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!=";"
            abort("ABORT printfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    def printfFuncCallTail(func)
        puts "IN printfFuncCallTail: #{$curToken.returnData}"
        if $curToken.returnData==","
            whichNext(func)
            expression(func)
        elsif $curToken.returnData==")"

        else
            abort("ABORT printfFuncCallTail: #{$curToken.returnData}")
        end 
    end

    def scanfFuncCall(func)
        puts "IN scanfFuncCall: #{$curToken.returnData}"
        if $curToken.returnData!="scanf"
            abort("ABORT scanfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!="("
            abort("ABORT scanfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!="string"
            abort("ABORT scanfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!=","
            abort("ABORT scanfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!="&"
            abort("ABORT scanfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        expression(func)
        if $curToken.returnData!=")"
            abort("ABORT scanfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!=";"
            abort("ABORT scanfFuncCall: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    def blockStatements(func)
        puts "IN blockStatements: #{$curToken.returnData}"
        if $curToken.returnData!="{"
            abort("ABORT blockStatements: #{$curToken.returnData}")
        end
        whichNext(func)
        statements(func)
        if $curToken.returnData!="}"
            abort("ABORT blockStatements: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    #def ifStatement()
    #    puts "IN ifStatement: #{$curToken.returnData}"
    #    if $curToken.returnData!="if"
    #        abort("ABORT ifStatement: #{$curToken.returnData}")
    #    end
    #    nextToken
    #    if $curToken.returnData!="("
    #        abort("ABORT ifStatement: #{$curToken.returnData}")
    #    end
    #    nextToken
    #    conditionExpression
    #    if $curToken.returnData!=")"
    #        abort("ABORT ifStatement: #{$curToken.returnData}")
    #    end
    #    nextToken
    #    blockStatements
    #    elseStatement
    #end

    def ifStatement(func)
        
        puts "IN ifStatement: #{$curToken.returnData}"
        if $curToken.returnData!="if"
            abort("ABORT ifStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!="("
            abort("ABORT ifStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        conditionExpression(func)
        if $curToken.returnData!=")"
            abort("ABORT ifStatement: #{$curToken.returnData}")
        end
        
        whichNext(func)
        $ifStatementTrue=1
        blockStatements(func)


        $labelCount+=1
        
        @newToken=TokenCalc.new("goto Label#{$labelCount} ","labelCall")
        @newTokenSemi=TokenCalc.new(";","semiEnd")
        $labelCount+=1
        @newTokenNext=TokenCalc.new("Label#{$labelCount}:;\n","labelCallNext")
        @newTokenNextForLabelReturn=TokenCalc.new("Label#{$labelCount};\n","labelCallNext")

        if func=="func"
            $tempFuncArray<<@newToken
            $tempFuncArray<<@newTokenSemi
            $tempFuncArray<<@newTokenNext
            
        elsif func=="maybefunc"
            $maybeFuncArray<<@newToken
            $maybeFuncArray<<@newTokenSemi
            $maybeFuncArray<<@newTokenNext
            
        end

        xstring=""
        for i in 1..$tempIfArray.length-2
            ystring=" #{$tempIfArray[i].returnData}"
            xstring<<ystring
        end
        @newTokenLabel=TokenCalc.new("Label#{$labelCount-1}:; #{xstring}\n goto #{@newTokenNextForLabelReturn.returnData}\n","labelDecl")
        $labelDefArray<<@newTokenLabel

        $tempIfArray.clear
        $ifStatementTrue=0
        elseStatement(func)
    end

    def elseStatement(func)
        puts "IN elseStatement: #{$curToken.returnData}"
        #the include? call is used to check for else\r. 
        #my tokenizer has trouble tokenizing string "else\r" as "else" using chomp or other ruby built functions for cutting end of line characters.
        #I have tried fixing this in the tokenizer, but the "else\r" string is no recognized by include? to have "else" in it or any other letters for that matter.
        #this was very strange and it seems that the \r somehow affects ruby's identification of the string.
        #because of this difficulty, I check for the case "else\r" in this include? call here.
        if $curToken.returnData=="else" || $curToken.returnData.include?("else") 
            whichNext(func)
            if $curToken.returnData=="{"
                blockStatements(func)
            else
                statements(func)
            end
        elsif $curToken.returnData=="}" || $curToken.returnData=="printf" || $curToken.returnData=="scanf" || $curToken.returnData=="if" || $curToken.returnData=="while" || $curToken.returnData=="return" || $curToken.returnData=="break" || $curToken.returnData=="continue" || $curToken.returnTok=="identifier"
        
        else
            abort("ABORT elseStatement: #{$curToken.returnData}")
        end
    end

    def comparisonOP(func)
        puts "IN comparisonOP: #{$curToken.returnData}"

        if $curToken.returnData=="=="
           whichNext(func)
        elsif $curToken.returnData=="!="
            whichNext(func)
        elsif $curToken.returnData==">"
            whichNext(func)
        elsif $curToken.returnData==">="
            whichNext(func)
        elsif $curToken.returnData=="<"
            whichNext(func)
        elsif $curToken.returnData=="<="
            whichNext(func)
        else 
            abort("ABORT comparisonOP: #{$curToken.returnData}")
        end
    end

    def whileStatement(func)
        puts "IN whileStatement: #{$curToken.returnData}"
        if $curToken.returnData!="while" 
            abort("ABORT whileStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!="(" 
            abort("ABORT whileStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        conditionExpression(func)
        if $curToken.returnData!=")" 
            abort("ABORT whileStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        blockStatements(func)
    end

    def returnStatement(func)
        puts "IN returnStatement: #{$curToken.returnData}"
        if $curToken.returnData!="return" 
            abort("ABORT returnStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        returnStatementTail(func)
        while $curToken.returnData=="+" || $curToken.returnData=="-" || $curToken.returnData=="*" || $curToken.returnData=="/"
            whichNext(func)
            returnStatementTail(func)
        end
        if $curToken.returnData!=";" 
            abort("ABORT returnStatement: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    def returnStatementTail(func)
        puts "IN returnStatementTail: #{$curToken.returnData}"
        if $curToken.returnTok=="identifier" || $curToken.returnTok=="number" || $curToken.returnData=="-" || $curToken.returnData=="("
            expression(func)
        elsif $curToken.returnData==";" 

        else
            abort("ABORT returnStatementTail: #{$curToken.returnData}")
        end        
    end

    def breakStatement(func)
        puts "IN breakStatement: #{$curToken.returnData}"
        if $curToken.returnData!="break" 
            abort("ABORT breakStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!=";" 
            abort("ABORT breakStatement: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    def continueStatement(func)
        puts "IN continueStatement: #{$curToken.returnData}"
        if $curToken.returnData!="continue" 
            abort("ABORT continueStatement: #{$curToken.returnData}")
        end
        whichNext(func)
        if $curToken.returnData!=";" 
            abort("ABORT continueStatement: #{$curToken.returnData}")
        end
        whichNext(func)
    end

    def conditionExpression(func)
        puts "IN conditionExpression: #{$curToken.returnData}"
        condition(func)
        conditionExpressionTail(func)
    end

    def conditionExpressionTail(func)
        puts "IN conditionExpressionTail: #{$curToken.returnData}"
        if $curToken.returnData=="&&" || $curToken.returnData=="||" 
            conditionOp(func)
            condition(func)
        elsif $curToken.returnData==")"

        else
            abort("ABORT conditionExpressionTail: #{$curToken.returnData}")
        end
    end

    def conditionOp(func)
        puts "IN conditionOp: #{$curToken.returnData}"
        if $curToken.returnData=="&&" || $curToken.returnData=="||"
           whichNext(func)
        else 
            abort("ABORT conditionOp: #{$curToken.returnData}")
        end
    end

    def condition(func)
        puts "IN condition: #{$curToken.returnData}"
        expression(func)
        while $curToken.returnData=="+" || $curToken.returnData=="-" || $curToken.returnData=="*" || $curToken.returnData=="/"
            whichNext(func)
            expression(func)
        end
        comparisonOP(func)
        expression(func)
    end

end
