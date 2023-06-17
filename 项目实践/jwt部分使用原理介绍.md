## jwt部分使用原理介绍

### 1、什么是jwt？

jwt的全称是JSON Web Token实际上就是一个做校验的token，根据一些传入参数等信息去生成token然后通过生成的token去对用户的身份等信息进行验证。

生成的token是这个样子：eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdXBlcmFkbWluIiwiY3JlYXRlZCI6MTY1MzI5NDY3NTQ2MSwiZXhwIjoxNjUzODk5NDc1LCJ1c2VySWQiOiItMSJ9.zFf85HvhFfupO1AZ_cgRBr5_ZbLl_5zpI7qEOvpopR1UeWn6wkgJXc2ePjDhiXXZSmkTmX6ibzHBi3lC3nXFZQ

通过.将这个分成三个部分，按顺序分别为：Header（加密方式）,Payload（参数啥的）,Signature（生成的真正的token），前两个都是base64（后面有演示），可以去解码看以下其中的各部分的信息。第三部分有点复杂，有兴趣可以去了解一下。

### 2、jwt生成token代码

先引入依赖：

	<dependency>
				<groupId>io.jsonwebtoken</groupId>
				<artifactId>jjwt</artifactId>
				<version>0.7.0</version>
	</dependency>

然后开始敲代码就行。

	String a = Jwts.builder()
		.signWith(SignatureAlgorithm.HS256, key)
		.setSubject("aaaa")
		.compact();
		System.out.println(a);
其中这个a就是生成的koken，里面的key就是秘钥，signwith就是使用特定的加密方式以及秘钥进行加密，SignatureAlgorithm里面有好多种不同的加密方式，可以随便选择。

set有几个特定的参数，可以往里面放，如果有其他的参数可以使用以下方式进行传入参数：

		Map map = new HashMap();
	    	map.put("username", "superadmin");
	    	map.put("userId", "-1");
	    	map.put("date", new Date());
	    	map.put("exp", new Date());
	    	map.put("out", 1);
	    	
		String a = Jwts.builder()
		.signWith(SignatureAlgorithm.HS256, key)
		.setClaims(map)
		.compact();
可以定义一个map将参数传入进去，同样可以达到相同的效果，个人感觉这个方式比较好，随便搞，但是有个小问题。

		Map map = new HashMap();
	    	map.put("sub", "superadmin");
	    	map.put("userId", "-1");
	    	map.put("date", new Date());
	    	map.put("exp", new Date());
	    	map.put("out", 1);
	    	
		
		String a = Jwts.builder()
		.signWith(SignatureAlgorithm.HS256, key)
		.setSubject("aaaa")
		.setClaims(map)
		.compact();
		System.out.println(a);
如果使用了setSubject而且map中也有sub这个参数，那么后面赋值的参数会直接覆盖前面的参数，可以试下代码修改下前后顺序测试一波。

这里还有一个小小的问题，就是这个key（秘钥）不能太短，如果太短会报错，这个报错提示也很有误导性。

明明不是空却提示下面的这个：secret key byte array cannot be null or empty.

经过测试，“111”不行，“1111”可以

### 3、jwt解密（应该是校验）

上面提到了生成的token是明文的，可以使用base64进行解密（应该叫转换），前两部分转换之后分别为：

{"alg":"HS256"}和{"date":1654131359488,"exp":1654131359488,"userId":"-1","username":"superadmin","out":1}

校验代码如下：

	Claims claims = Jwts.parser().setSigningKey(key).parseClaimsJws(a).getBody();

​	通过以上代码可以对token进行校验，此时如果这个秘钥不对的话会直接报错。

JWT signature does not match locally computed signature. JWT validity cannot be asserted and should not be trusted.

提示校验失败。

返回的这个Claims可以直接用get方法获取里面的参数即可。

代码合并起来就是：

	Claims claims = Jwts.parser().setSigningKey(key).parseClaimsJws(a).getBody();
	System.out.println(claims.get("date"));
	System.out.println(claims.getSubject());
	System.out.println(claims.getExpiration());
	System.out.println(claims.get("out"));

如果没有值的话直接就会返回一个null，然后根据里面的值啥的自己去判断就可以了。

### 4、还有一个遗留的问题：

秘钥是1111和11111使用HS256加密好像有点问题，实际上key不一样，但是却可以校验成功。。

代码演示一下。请大佬讲解一波。























