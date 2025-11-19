//设置语言
var locale = 'en-us';
var getLang = function() {
	var zh_index = location.href.indexOf('zh-cn');
	if(zh_index == -1) {
		return 'en-us';
	}else{
		return 'zh-cn';
	}
};

//i18n for header and footer
var i18n_header_footer = {
	'en-us': {
		'issf': 'Symposium on Blockchain Technology Application 2019',
		'home': 'Home',
		'about': 'About',
		'committees': 'Committees',
		'submission': 'Submission',
		'guide': 'Guide',
		'registration': 'Registration',
		'speakers': 'Speakers',
		'program': 'Program',
		'researchcamps': 'Research Camp<span class="hot-icon glyphicon glyphicon-fire"></span>',
		'competition': 'Competition<span class="hot-icon glyphicon glyphicon-fire"></span>',
		'contactus': 'Contact Us',
		
		'home_value': 'index.html',
		'about_value': 'about.html',
		'committees_value': 'committees.html',
		'submission_value': 'submission.html',
		'guide_value': 'guide.html',
		'registration_value': 'registration.html',
		'speakers_value': 'speakers.html',
		'program_value': 'program.html',
		'researchcamps_value': 'researchcamps.html',
		'competition_value': 'competition.html',
		'contactus_value': 'contactus.html',

		'host': 'hosts',
		'contact': 'Secretariat of ICSF 2023',
		'wechat': 'official wechat',
		'CGIF': 'Center on Global Internet Finance, City University of Hong Kong',
		'NSFC': 'National Natural Science Foundation of China',
		'CB': 'The College of Business, City University of Hong Kong',
		'tel': 'Tel',
		'fax': 'Fax',
		'email': 'Email',
		'address_title': 'Conference Address',
		'address': 'City University of Hong Kong SRI',
		'lang-title': '转换语言为中文',
		'div-lang-title': '中文',
		'lang-img': 'res/images/zh_cn.png'
	},
	
	'zh-cn': {
		'issf': '2016国际智慧金融峰会',
		'home': '首页',
		'about': '关于',
		'committees': '组委会',
		'submission': '论文投稿',
		'guide': '指引',
		'registration': '注册',
		'speakers': '主讲嘉宾',
		'program': '日程',
		'researchcamps': '科研辅导<span class="hot-icon glyphicon glyphicon-fire"></span>',
		'competition': '峰会竞赛<span class="hot-icon glyphicon glyphicon-fire"></span>',
		'contactus': '联系我们',
		
		'home_value': 'index_zh-cn.html',
		'about_value': 'about_zh-cn.html',
		'committees_value': 'committees_zh-cn.html',
		'submission_value': 'submission_zh-cn.html',
		'guide_value': 'guide_zh-cn.html',
		'registration_value': 'registration_zh-cn.html',
		'speakers_value': 'speakers_zh-cn.html',
		'program_value': 'program_zh-cn.html',
		'researchcamps_value': 'researchcamps_zh-cn.html',
		'competition_value': 'competition_zh-cn.html',
		'contactus_value': 'contactus_zh-cn.html',

		'host': '主办方',
		'contact': 'ISSF 2016 秘书组',
		'wechat': '官方公众号',
		'CGIF': '香港城市大学国际互联网金融中心',
		'NSFC': '中国国家自然科学基金会',
		'CB': '香港城市大学商学院',
		'tel': '电话',
		'fax': '传真',
		'email': '邮箱',
		'address_title': '会议地址',
		'address': '香港城市大学深圳研究院',
		'lang-title': 'Change language to English',
		'div-lang-title': 'English',
		'lang-img': 'res/images/en_us.png'
	}
};

var generateHeaderFrame = function() {
	return  '<div class="container">'+
		    '	<div class="row">' + 
			'		<div class="navbar-header">' + 
			'			<button type="button" class="navbar-toggle" data-toggle="collapse" ' +  
			'				 data-target="#navbar-collapse">' + 
			'				 <span class="icon-bar"></span>' + 
			'				 <span class="icon-bar"></span>' + 
			'				 <span class="icon-bar"></span>' + 
			'				 <span class="menu-tip">MENU</span>' + 
			'			</button>' + 
			'' + 
			'			<div class="navbar-brand">' + 
			'				<div class="brand-link">' + 
			'					<a title="International Conference on Smart Finance 2023" href="index.html">' + 
			'						ICSF 2023' + 
			'					</a>' + 
			'				</div>' + 
			'			</div>' + 
			'		</div>' + 
			'' + 
			'		<div class="menu-panel col-md-10 col-sm-12 col-xs-12">' + 
			'			<div class="collapse navbar-collapse" id="navbar-collapse">' + 
			'		   		<div class="nav nav-main">' + 
			'		   			<div class="container-fluid">' + 
			'		   				<div class="row">' + 
			'		   					<div class="col-md-2 col-sm-12 col-xs-12 menu-item active">' + 
			'		   						<a id="menu_home" href="index.html">Home</a>' + 
			'		   					</div>' + 
			'		   					<div class="col-md-2 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_about" href="about.html">About</a>' + 
			'		   					</div>' + 
			'		   					<div class="col-md-3 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_speakers" href="speakers.html">Speakers</a>' + 
			'		   					</div>' + 
			'		   					<div class="col-md-2 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_committees" href="committees.html">Committees</a>' + 
			'		   					</div>' + 
			'		   					<div class="col-md-3 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_program" href="program.html">Program</a>' + 
			'		   					</div>' + 
			'		   				</div>' + 
			'		   				<div class="row">' + 
			'		   					<div class="col-md-2 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_guide" href="guide.html">Guide</a>' + 
			'		   					</div>' + 
			'		   					<div class="col-md-2 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_submission" href="submission.html">Submission</a>' + 
			'		   					</div>' + 
			'		   					<div class="col-md-3 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_registration" href="registration.html">Registration</a>' + 
			'		   					</div>' + 
			'		   					<div class="col-md-2 col-sm-12 col-xs-12 menu-item">' + 
			'		   						<a id="menu_contactus" href="contactus.html">Contact Us</a>' + 
			'		   					</div>' +
			'		   				</div>' + 
			'		   			</div>' + 
			'		   		</div>' + 
			'		   </div>' + 	
			'		</div>' + 
			'	</div>' + 
		    '</div>';
};

var generateHeader = function(p_locale) {
	//generate header frame
	$('.navbar.navbar-default').html(generateHeaderFrame());

	//language setting
	$('#language').attr('title', i18n_header_footer[p_locale]['lang-title']);
	$('#language > .lang-img').attr('src', i18n_header_footer[p_locale]['lang-img']);
	$('#language > .title').html(i18n_header_footer[p_locale]['div-lang-title']);

	//menu setting
	$('#menu_home').html(i18n_header_footer[p_locale]['home']);
	$('#menu_home').attr('href', i18n_header_footer[p_locale]['home_value']);

	$('#menu_about').html(i18n_header_footer[p_locale]['about']);
	$('#menu_about').attr('href', i18n_header_footer[p_locale]['about_value']);

	$('#menu_speakers').html(i18n_header_footer[p_locale]['speakers']);
	$('#menu_speakers').attr('href', i18n_header_footer[p_locale]['speakers_value']);

	$('#menu_researchcamps').html(i18n_header_footer[p_locale]['researchcamps']);
	$('#menu_researchcamps').attr('href', i18n_header_footer[p_locale]['researchcamps_value']);

	$('#menu_committees').html(i18n_header_footer[p_locale]['committees']);
	$('#menu_committees').attr('href', i18n_header_footer[p_locale]['committees_value']);

	$('#menu_program').html(i18n_header_footer[p_locale]['program']);
	$('#menu_program').attr('href', i18n_header_footer[p_locale]['program_value']);

	$('#menu_guide').html(i18n_header_footer[p_locale]['guide']);
	$('#menu_guide').attr('href', i18n_header_footer[p_locale]['guide_value']);

	$('#menu_submission').html(i18n_header_footer[p_locale]['submission']);
	$('#menu_submission').attr('href', i18n_header_footer[p_locale]['submission_value']);

	$('#menu_registration').html(i18n_header_footer[p_locale]['registration']);
	$('#menu_registration').attr('href', i18n_header_footer[p_locale]['registration_value']);

	$('#menu_competition').html(i18n_header_footer[p_locale]['competition']);
	$('#menu_competition').attr('href', i18n_header_footer[p_locale]['competition_value']);

	$('#menu_contactus').html(i18n_header_footer[p_locale]['contactus']);
	$('#menu_contactus').attr('href', i18n_header_footer[p_locale]['contactus_value']);

	//set active menu bar
	var pageIndexBegin = location.href.lastIndexOf('/');
	var dotBegin 	   = location.href.lastIndexOf('.');
	if(dotBegin > pageIndexBegin) {
		$('.menu-panel .menu-item').removeClass('active');

		var base = location.href.substring(0, pageIndexBegin+1);
		var page = location.href.substring(pageIndexBegin+1, dotBegin);
		
		var isChinese = page.indexOf('zh-cn') > 0 ? true : false;
		var pageOrigin = '';
		if(isChinese) {
			var pageArray = page.split('_');
			pageOrigin = pageArray[0];
		}else{
			pageOrigin = page;
		}

		//match
		if(pageOrigin == 'index') {
			$('#menu_home').parent().addClass('active');
		}else if(pageOrigin == 'about') {
			$('#menu_about').parent().addClass('active');
		}else if(pageOrigin == 'committees') {
			$('#menu_committees').parent().addClass('active');
		}else if(pageOrigin == 'submission') {
			$('#menu_submission').parent().addClass('active');
		}else if(pageOrigin == 'guide') {
			$('#menu_guide').parent().addClass('active');
		}else if(pageOrigin == 'registration') {
			$('#menu_registration').parent().addClass('active');
		}else if(pageOrigin == 'speakers') {
			$('#menu_speakers').parent().addClass('active');
		}else if(pageOrigin == 'program') {
			$('#menu_program').parent().addClass('active');
		}else if(pageOrigin == 'researchcamps') {
			$('#menu_researchcamps').parent().addClass('active');
		}else if(pageOrigin == 'competition') {
			$('#menu_competition').parent().addClass('active');
		}else if(pageOrigin == 'contactus') {
			$('#menu_contactus').parent().addClass('active');
		}else{
			$('#menu_home').parent().addClass('active');
		}
	}
};

var generateFooterFrame = function() {
	return  '<div class="container">' + 
			'	<div class="row">' + 
			'		<a href="guide.html#map" target="_blank" style="text-decoration:none;">Conference Address</a>/ ' + 
			'ICSF 2023' +
			'		Copyright © 2023 <span>University of Wollongong in Dubai</span> All rights reserved.' + 
		   
		    '</div>' +
		    '</div>';
};

var generateFooter = function(p_locale) {
	//generate footer frame
	$('#footer').html(generateFooterFrame());

	//set footer language
	var html_text =  
					 
					'<a href="guide.html#map" target="_blank" style="text-decoration:none;">' + 
					i18n_header_footer[p_locale]['address_title'] + '</a>&nbsp;/&nbsp;' + 
					'ICSF 2023 Copyright © 2023 <span>University of Wollongong in Dubai</span> All rights reserved.';

	$('#footer .row').html(html_text);	
};

var initHeaderAndFooter = function() {
	//language
	local = getLang();

	//module
	generateHeader(local);
	generateFooter(local);

	//click event
	$('.switch-lang').click(function(event) {	
		//refresh page according to language
		var pageIndexBegin = location.href.lastIndexOf('/');
		var dotBegin 	   = location.href.lastIndexOf('.');
		if(dotBegin <= pageIndexBegin) {
			location.href = location.href + 'index.html';
		}else{
			var base = location.href.substring(0, pageIndexBegin+1);
			var page = location.href.substring(pageIndexBegin+1, dotBegin);
			
			var isChinese = page.indexOf('zh-cn') > 0 ? true : false;
			var pageOrigin = '';
			if(isChinese) {
				var pageArray = page.split('_');
				pageOrigin = pageArray[0];
			}else{
				pageOrigin = page;
			}

			if(!isChinese) {
				location.href = base + pageOrigin + '_zh-cn.html';
			}else{
				location.href = base + pageOrigin + '.html';
			}
		}

		//scroll to top
		$('body').scrollTop(0);
	});
};

//初始化页面顶部和底部
initHeaderAndFooter();

