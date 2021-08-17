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
	import tf.transformations as tfm
	使用tfm做坐标变化时需要注意动态变化和静态变化，sxyz = rzyx
	kuka，fanuc，yaskawa的转换顺序是一样的
	沿法兰动态变换，矩阵右乘，用原本的矩阵乘以新的T
	tf_base_current = self.pose2tf(current_pose)
        if frame == 'flange':
            if move_mode == 'translate':
                rot_current_target = np.eye(3)
                trans_current_target = step * np.array(axis)
                tf_current_target = np.eye(4)
                tf_current_target[:3, :3] = rot_current_target
                tf_current_target[:3, 3] = trans_current_target
            else:
                trans_current_target = np.array([0, 0, 0])
                euler_ang = np.deg2rad(step) * np.array(axis)
                qt_current_target = tfm.quaternion_from_euler(euler_ang[0], euler_ang[1], euler_ang[2], 'sxyz')
                tf_current_target = tfm.quaternion_matrix(qt_current_target)
            tf_base_target = np.matmul(tf_base_current, tf_current_target)
	沿世界坐标变化，矩阵左乘，原本的矩阵左乘新的T
	else:
	if move_mode == 'translate':
                rot_current_target = np.eye(3)
                trans_current_target = step * np.array(axis)
                tf_base_target = tf_base_current
                tf_base_target[:3, 3] = tf_base_current[:3, 3] + trans_current_target
            else:
                trans_current_target = np.array([0, 0, 0])
                euler_ang = np.deg2rad(step) * np.array(axis)
                qt_current_target = tfm.quaternion_from_euler(euler_ang[0], euler_ang[1], euler_ang[2], 'sxyz')
                tf_current_target = tfm.quaternion_matrix(qt_current_target)
                # Multiply the rotation matrix on the left as it rotates around the base axes
                rotate = np.matmul(tf_current_target[:3, :3], tf_base_current[:3, :3])
                tf_base_target = np.eye(4)
                tf_base_target[:3, :3] = rotate
                tf_base_target[:3, 3] = tf_base_current[:3, 3]
        pose_base_target = self.tf2pose(tf_base_target)
        return pose_base_target
