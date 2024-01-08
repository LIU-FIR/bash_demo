#! /opt/homebrew/bin/bash #bash所在的实际路径

# 1，解析命令行参数，如./readvar.sh -t 150
while getopts 't:' OPTION; do # ':'代表 -t 后要有内容 
  case "$OPTION" in
    t)
      nsecond="$OPTARG" #存储环境变量OPTARG到变量nsecond中
    #   echo "The time is set $OPTARG"
      ;;
    ?)
      echo "script usage: $(basename $0) [-t somevalue]" >&2 # 错误结果重定向到stderr,&代表后面是文件描述符
      exit 1
      ;;
  esac
done
#变量$OPTIND在getopts开始执行前是1，然后每次执行就会加1。
#退出while循环时意味着连词线参数全部处理完毕。
#$OPTIND-1就是已经处理的连词线参数个数，
#使用shift命令将这些参数移除，保证后面的代码可以用$1、$2等处理命令的主参数。
shift "$(($OPTIND - 1))"

# 2，读取udp.h文件中的相应数值
filename='/Users/feiliu/git_codes/bash_demo/udp.h'

LINE_NO=16 #udp.h中PKT_DTSZ 所在行编号
i=0
while read myline; do
    i=$((i+1))
    if [ $i -eq $LINE_NO ];then
        linestr=$myline
        break
    fi
done < $filename #将文件内容定向到read 的myline变量中，每次读1行，到相应行时存储行myline到linestr

# -[16]- define PKT_DTSZ   4096
pkt_dtsz=${linestr: -4:4} # -4代表从倒数第4个字符开始，:4代表长度
echo "The pkt_dtsz is: $pkt_dtsz"

if [ -z "$OPTARG" ];then # 如果命令行-t参数为空，设置nsecond为默认值
    nsecond=10
fi
echo "The time is: $nsecond sec"

