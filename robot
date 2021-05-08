机器人运动学正解：坐标系推算关节角
机器人运动学逆解：根据关节叫推算坐标系
	根据D-H参数表求逆解
	ABB逆解求值过程中有confdata指定轴相关的象限

ABB
socket:
	VAR socketdev serverSocket;
	VAR socketdev clientSocket;
	SocketCreate serverSocket;
	SocketBind serverSocket,ip,port;
	SocketListen serverSocket;
	WHILE SocketGetStatus(clientSocket) <>SOCKET_CONNECTED DO
		SocketAccept serverSocket,clientSocket\ClientAddress:=clientIP\Time:=WAIT_MAX;
	
解析字符串：
	newInd := StrMatch(msg, ind, " ")+1;		#在字符串中搜索结束下标（以" "结尾）
	subString := StrPart(msg, ind, newInd-ind-1);	
	auxOK := StrToVal(subString, instructionCode);

机器人四元数：
	公司内部定义q1, q2, q3, q4 = qw, qx, qy, qz

confdata:
	指定机器人轴配置相关，VAR confdata conf_data:=[1, -1, 0, 0]
	指机械臂轴1配置为象限1,90-180度
	指机械臂轴4配置为象限-1,0-(-90)度
	指机械臂轴6配置为象限0,0-90度
	指机械臂轴x配置为象限0,0-90度
		cfx=0机器人四轴标签是正的
		cfx=1机器人四轴反转
		......
	从零开始，正向旋转
		象限0	0-90度
		象限1	90-180度
		象限2	180-270度
		象限3	270-360度
	从零开始，逆向旋转
		象限-1	0-(-90)度
		象限-2	(-90)-(-180)度
		象限-3	(-180)-(-270)度
		象限-4	(-270)-(-360)度

矩阵变换
