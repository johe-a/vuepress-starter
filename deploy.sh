#!/usr/bin/env sh
. ./test.sh
echo "${user}"

# 确保脚本抛出遇到的错误
set -e

# your_name="johehuang"

# echo ${your_name}

# for skill in Ada Coffe Action Java; do
#   echo "i am good at ${skill}Script"
# done

# array=(1 2 3 4)
# echo ${#array[@]}

# a=1
# b=2

# if [ $a -lt $b ]
# then
#   echo `expr $a - $b`
# else 
#   echo `expr $b - $a`
# fi

# echo `expr 2 + 2`

# if [ ${#array[@]} -eq 4 ] 
# then 
#   echo 'length of array is equal to 4'
# fi

# echo `date`

# printf "%-10s %-10s %-4s\n" 姓名 性别 体重kg
# printf "%-10s %-10s %-4.2f\n" 黄嘉豪 男 60.222222
# printf "%-10s %-10s %-4.2f\n" 徐菁菁 女 50.222222

# readNum() {
#   echo "函数计算两数之和"
#   echo "请输入第一个数字"
#   read aNum
#   echo "输入第二个数字"
#   read bNum
#   expr ${aNum} + ${bNum}
# }
# readNum 3
# echo $?

# cat << EOF
# 谢谢你们
# 来这里看我
# EOF




# 生成静态文件
npm run docs:build

# 进入生成的文件夹
cd docs/.vuepress/dist

# 初始化git
git init
# 提交dist下的文件
git add -A 
git commit -m 'deploy'

git push -f git@github.com:johe-a/vuepress-page.git master:deploy