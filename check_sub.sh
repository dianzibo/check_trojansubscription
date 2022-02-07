#!/bin/sh
#dianzibo
######################################################
######################################################
######################################################
##############联系方式:dingdluan@gmail.com#############

#########系统log行数变化统计
###首次执行程序，创建pre文件
if [ ! -f /var/log/log_line_pre.txt ]; then
	echo $(wc -l /var/log/httpd/ssl_request_log| awk '{print $1}') > /var/log/log_line_pre.txt
	exit 0
fi

log_line_pre=$(cat /var/log/log_line_pre.txt)
log_line_now=$(wc -l /var/log/httpd/ssl_request_log| awk '{print $1}')
if [ $log_line_now -lt $log_line_pre ];then
	line_start=1
	line_end=$log_line_now
	echo $log_line_now > /var/log/log_line_pre.txt
elif [ $log_line_now == $log_line_pre ];then
	exit 0
else 
	line_start=$[$log_line_pre+1]
	line_end=$log_line_now
	echo $log_line_now > /var/log/log_line_pre.txt
fi

#########检查selfcheck_clash_ss.txt文件行数是否超标
time_now=$(date +%Y%m%d%H)
check_line=$(wc -l $(your own local path)/selfcheck_clash_ss.txt | awk '{print $1}')
if [ $check_line -gt 50 ];then
	mv $(your own local path)/selfcheck_clash_ss.txt $(your own cloud path)/subscript_backup/selfcheck_clash_ss_$time_now.txt 
fi


######统计subss订阅情况
###判断日志是否被更新
if test ! -z "$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subss)"; then
	###获取更新的行数个数
	line=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subss|wc -l);
	###获取更新日志细节
	#获取ip组：
	ip_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subss|awk '{print$3}');
	#获取日期组：
	day_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subss|awk '{print$1}'|awk -F '[' '{print $2}'|awk -F '/' '{print $1}');
	#获取月份组：
	mom_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subss|awk '{print $1}'|awk -F '/' '{print $2}');
	#获取时间组：
	time_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subss|awk '{print $1}'|awk -F '/' '{print $3}');
	#获取客户端信息：
	client_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subss|awk -F '"' '{print $4}'|awk '{print $1$2$3$4$5$6$7$8$9$10$11$12$13$14$15$16$17$18$19$20}');
	###循环遍历
	i=1;
	while [ $[ $line - $i + 1 ] -ne 0 ];do
		ip=$(echo $ip_group |awk '{print $'$i'}');
		day=$(echo $day_group |awk '{print $'$i'}');
		mom=$(echo $mom_group |awk '{print $'$i'}');
		time=$(echo $time_group |awk '{print $'$i'}');
		clientinfo=$(echo $client_group |awk '{print $'$i'}');
		#获取ip地址的地理信息：
		ipinfo=$(curl -s cip.cc/$ip);
		city=$(echo $ipinfo |awk -F ':' '{print $3}'|awk -F ' ' '{print $1$2$3}');
		echo $mom$day $time $ip $city $clientinfo, 'subss订阅提醒' >> $(your own local path)/selfcheck_clash_ss.txt;
		i=$[$i+1];
		#设置查询时间间隔遵守api规则
		sleep 3;
	done
	echo -e "亲爱的丁丁，又有宝贝订阅了你的服务器啦～ \nip地址:$ip \n地理位置是:$city \n快来查看一下具体情况吧～" | mail -v -s "subss订阅提醒" dingdluan@gmail.com
	rm -rf $(your own cloud path)/selfcheck_clash_ss.txt
	cp -rf $(your own local path)/selfcheck_clash_ss.txt $(your own cloud path)/selfcheck_clash_ss.txt
fi

######统计dingdingding.yaml订阅情况
###判断日志是否被更新
if test ! -z "$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subclash)"; then
	###获取更新的行数个数
	line=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subclash|wc -l);
	###获取更新日志细节
	#获取ip组：
	ip_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subclash|awk '{print$3}');
	#获取日期组：
	day_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subclash|awk '{print$1}'|awk -F '[' '{print $2}'|awk -F '/' '{print $1}');
	#获取月份组：
	mom_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subclash|awk '{print $1}'|awk -F '/' '{print $2}');
	#获取时间组：
	time_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subclash|awk '{print $1}'|awk -F '/' '{print $3}');
	#获取客户端信息：
	client_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p'|grep subclash|awk -F '"' '{print $4}'|awk '{print $1$2$3$4$5$6$7$8$9$10$11$12$13$14$15$16$17$18$19$20}');
	#获取客户md5订阅码：
	md5_group=$(cat /var/log/httpd/ssl_request_log|sed -n ''$line_start','$line_end'p' |grep subclash| awk -F 'subclash' '{print$2}'|awk '{print$1}'|awk -F '/' '{print$2}')
	###循环遍历
	i=1;
	while [ $[ $line - $i + 1 ] -ne 0 ];do
		ip=$(echo $ip_group |awk '{print $'$i'}');
		day=$(echo $day_group |awk '{print $'$i'}');
		mom=$(echo $mom_group |awk '{print $'$i'}');
		time=$(echo $time_group |awk '{print $'$i'}');
		clientinfo=$(echo $client_group |awk '{print $'$i'}');
		md5info=$(echo $md5_group |awk '{print $'$i'}');
		#获取ip地址的地理信息：
		ipinfo=$(curl -s cip.cc/$ip);
		city=$(echo $ipinfo |awk -F ':' '{print $3}'|awk -F ' ' '{print $1$2$3}');
		#获取订阅用户的备注名
		username=$(grep -n $md5info $(your own cloud path)/customClash/subname_table.log|awk '{print$2}')
		#输出信息
		echo $mom$day $time $ip $city $clientinfo, $username, 'clash订阅提醒' >> $(your own local path)/selfcheck_clash_ss.txt;
		i=$[$i+1];
		#设置查询时间间隔遵守api规则
		sleep 3;
	done
	echo -e "亲爱的丁丁，$username订阅了你的服务器啦 \nip地址是:$ip \n地理位置为:$city \n客户端是:$clientinfo \n快来查看一下具体情况吧～" | mail -v -s "clash订阅提醒" dingdluan@gmail.com
	rm -rf $(your own cloud path)/selfcheck_clash_ss.txt
	cp -rf $(your own local path)/selfcheck_clash_ss.txt $(your own cloud path)/selfcheck_clash_ss.txt
fi

