# Insert server unique id if it doesn't exist
RocketChat.settings.add('uniqueID', process.env.DEPLOYMENT_ID or Random.id(), { public: true, hidden: true });

# When you define a setting and want to add a description, you don't need to automatically define the i18nDescription
# if you add a node to the i18n.json with the same setting name but with `_Description` it will automatically work.
RocketChat.settings.addGroup 'Accounts', ->
	@add 'Accounts_AllowDeleteOwnAccount', false, { type: 'boolean', public: true, enableQuery: { _id: 'Accounts_AllowUserProfileChange', value: true } }
	@add 'Accounts_AllowUserProfileChange', true, { type: 'boolean', public: true }
	@add 'Accounts_AllowUserAvatarChange', true, { type: 'boolean', public: true }
	@add 'Accounts_AllowUsernameChange', true, { type: 'boolean', public: true }
	@add 'Accounts_AllowEmailChange', true, { type: 'boolean', public: true }
	@add 'Accounts_AllowPasswordChange', true, { type: 'boolean', public: true }
	@add 'Accounts_LoginExpiration', 90, { type: 'int', public: true }
	@add 'Accounts_ShowFormLogin', true, { type: 'boolean', public: true }
	@add 'Accounts_EmailOrUsernamePlaceholder', '', { type: 'string', public: true, i18nLabel: 'Placeholder_for_email_or_username_login_field' }
	@add 'Accounts_PasswordPlaceholder', '', { type: 'string', public: true, i18nLabel: 'Placeholder_for_password_login_field' }
	@add 'Accounts_ForgetUserSessionOnWindowClose', false, { type: 'boolean', public: true }

	@section 'Registration', ->
		@add 'Accounts_RequireNameForSignUp', true, { type: 'boolean', public: true }
		@add 'Accounts_RequirePasswordConfirmation', true, { type: 'boolean', public: true }
		@add 'Accounts_EmailVerification', false, { type: 'boolean', public: true, enableQuery: {_id: 'SMTP_Host', value: { $exists: 1, $ne: "" } } }
		@add 'Accounts_ManuallyApproveNewUsers', false, { type: 'boolean' }
		@add 'Accounts_AllowedDomainsList', '', { type: 'string', public: true }

		@add 'Accounts_BlockedDomainsList', '', { type: 'string' }
		@add 'Accounts_BlockedUsernameList', '', { type: 'string' }
		@add 'Accounts_UseDefaultBlockedDomainsList', true, { type: 'boolean' }
		@add 'Accounts_UseDNSDomainCheck', false, { type: 'boolean' }

		@add 'Accounts_RegistrationForm', 'Public', { type: 'select', public: true, values: [ { key: 'Public', i18nLabel: 'Accounts_RegistrationForm_Public' }, { key: 'Disabled', i18nLabel: 'Accounts_RegistrationForm_Disabled' }, { key: 'Secret URL', i18nLabel: 'Accounts_RegistrationForm_Secret_URL' } ] }
		@add 'Accounts_RegistrationForm_SecretURL', Random.id(), { type: 'string' }
		@add 'Accounts_RegistrationForm_LinkReplacementText', 'New user registration is currently disabled', { type: 'string', public: true }
		@add 'Accounts_Registration_AuthenticationServices_Enabled', true, { type: 'boolean', public: true }
		@add 'Accounts_PasswordReset', true, { type: 'boolean', public: true }

		@add 'Accounts_CustomFields', '', { type: 'code', public: true, i18nLabel: 'Custom_Fields' }

	@section 'Avatar', ->
		@add 'Accounts_AvatarResize', true, { type: 'boolean' }
		@add 'Accounts_AvatarSize', 200, { type: 'int', enableQuery: {_id: 'Accounts_AvatarResize', value: true} }
		@add 'Accounts_AvatarStoreType', 'GridFS', { type: 'select', values: [ { key: 'GridFS', i18nLabel: 'GridFS' }, { key: 'FileSystem', i18nLabel: 'FileSystem' } ] }
		@add 'Accounts_AvatarStorePath', '', { type: 'string', enableQuery: {_id: 'Accounts_AvatarStoreType', value: 'FileSystem'} }

RocketChat.settings.addGroup 'OAuth', ->

	@section 'Facebook', ->
		enableQuery = { _id: 'Accounts_OAuth_Facebook', value: true }
		@add 'Accounts_OAuth_Facebook', false, { type: 'boolean', public: true }
		@add 'Accounts_OAuth_Facebook_id', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Facebook_secret', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Facebook_callback_url', '_oauth/facebook', { type: 'relativeUrl', readonly: true, force: true, enableQuery: enableQuery }

	@section 'Google', ->
		enableQuery = { _id: 'Accounts_OAuth_Google', value: true }
		@add 'Accounts_OAuth_Google', false, { type: 'boolean', public: true }
		@add 'Accounts_OAuth_Google_id', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Google_secret', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Google_callback_url', '_oauth/google', { type: 'relativeUrl', readonly: true, force: true, enableQuery: enableQuery }

	@section 'GitHub', ->
		enableQuery = { _id: 'Accounts_OAuth_Github', value: true }
		@add 'Accounts_OAuth_Github', false, { type: 'boolean', public: true }
		@add 'Accounts_OAuth_Github_id', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Github_secret', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Github_callback_url', '_oauth/github', { type: 'relativeUrl', readonly: true, force: true, enableQuery: enableQuery }

	@section 'Linkedin', ->
		enableQuery = { _id: 'Accounts_OAuth_Linkedin', value: true }
		@add 'Accounts_OAuth_Linkedin', false, { type: 'boolean', public: true }
		@add 'Accounts_OAuth_Linkedin_id', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Linkedin_secret', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Linkedin_callback_url', '_oauth/linkedin', { type: 'relativeUrl', readonly: true, force: true, enableQuery: enableQuery }

	@section 'Meteor', ->
		enableQuery = { _id: 'Accounts_OAuth_Meteor', value: true }
		@add 'Accounts_OAuth_Meteor', false, { type: 'boolean', public: true }
		@add 'Accounts_OAuth_Meteor_id', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Meteor_secret', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Meteor_callback_url', '_oauth/meteor', { type: 'relativeUrl', readonly: true, force: true, enableQuery: enableQuery }

	@section 'Twitter', ->
		enableQuery = { _id: 'Accounts_OAuth_Twitter', value: true }
		@add 'Accounts_OAuth_Twitter', false, { type: 'boolean', public: true }
		@add 'Accounts_OAuth_Twitter_id', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Twitter_secret', '', { type: 'string', enableQuery: enableQuery }
		@add 'Accounts_OAuth_Twitter_callback_url', '_oauth/twitter', { type: 'relativeUrl', readonly: true, force: true, enableQuery: enableQuery }


RocketChat.settings.addGroup 'General', ->

	@add 'Site_Url', __meteor_runtime_config__?.ROOT_URL, { type: 'string', i18nDescription: 'Site_Url_Description', public: true }
	@add 'Site_Name', 'Ecclesia.Chat', { type: 'string', public: true }
	@add 'Language', '', { type: 'language', public: true }
	@add 'Allow_Invalid_SelfSigned_Certs', false, { type: 'boolean' }
	@add 'Favorite_Rooms', true, { type: 'boolean', public: true }
	@add 'CDN_PREFIX', '', { type: 'string' }
	@add 'Force_SSL', false, { type: 'boolean', public: true }
	@add 'GoogleTagManager_id', '', { type: 'string', public: true }
	@add 'Bugsnag_api_key', '', { type: 'string', public: false }
	@add 'Restart', 'restart_server', { type: 'action', actionText: 'Restart_the_server' }

	@section 'UTF8', ->
		@add 'UTF8_Names_Validation', '[0-9a-zA-Z-_.]+', { type: 'string', public: true, i18nDescription: 'UTF8_Names_Validation_Description'}
		@add 'UTF8_Names_Slugify', true, { type: 'boolean', public: true }

	@section 'Reporting', ->
		@add 'Statistics_reporting', true, { type: 'boolean' }

	@section 'Notifications', ->
		@add 'Desktop_Notifications_Duration', 0, { type: 'int', public: true, i18nDescription: 'Desktop_Notification_Durations_Description' }

	@section 'REST API', ->
		@add 'API_User_Limit', 500, { type: 'int', public: true, i18nDescription: 'API_User_Limit' }

	@section 'Iframe Integration', ->
		@add 'Iframe_Integration_send_enable', false, { type: 'boolean', public: true }
		@add 'Iframe_Integration_send_target_origin', '*', { type: 'string', public: true, enableQuery: { _id: 'Iframe_Integration_send_enable', value: true } }

		@add 'Iframe_Integration_receive_enable', false, { type: 'boolean', public: true }
		@add 'Iframe_Integration_receive_origin', '*', { type: 'string', public: true, enableQuery: { _id: 'Iframe_Integration_receive_enable', value: true } }

	@section 'Translations', ->
		@add 'Custom_Translations', '', { type: 'code', public: true }

	@section 'Stream Cast', ->
		@add 'Stream_Cast_Address', '', { type: 'string' }

RocketChat.settings.addGroup 'Email', ->
	@section 'Header and Footer', ->
		@add 'Email_Header', '<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#f3f3f3" style="color:#4a4a4a;font-family: Helvetica,Arial,sans-serif;font-size:14px;line-height:20px;border-collapse:callapse;border-spacing:0;margin:0 auto"><tr><td style="padding:1em"><table border="0" cellspacing="0" cellpadding="0" align="center" width="100%" style="width:100%;margin:0 auto;max-width:800px"><tr><td bgcolor="#ffffff" style="background-color:#ffffff; border: 1px solid #DDD; font-size: 10pt; font-family: Helvetica,Arial,sans-serif;"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td style="background-color: #04436a;"><h1 style="font-family: Helvetica,Arial,sans-serif; padding: 0 1em; margin: 0; line-height: 70px; color: #FFF;">[Site_Name]</h1></td></tr><tr><td style="padding: 1em; font-size: 10pt; font-family: Helvetica,Arial,sans-serif;">', {
			type: 'code',
			code: 'text/html',
			multiline: true,
			i18nLabel: 'Header'
		}
		@add 'Email_Footer', '</td></tr></table></td></tr><tr><td border="0" cellspacing="0" cellpadding="0" width="100%" style="font-family: Helvetica,Arial,sans-serif; max-width: 800px; margin: 0 auto; padding: 1.5em; text-align: center; font-size: 8pt; color: #999;">Powered by <a href="https://rocket.chat" target="_blank">Rocket.Chat</a></td></tr></table></td></tr></table>', {
			type: 'code',
			code: 'text/html',
			multiline: true,
			i18nLabel: 'Footer'
		}

	@section 'SMTP', ->
		@add 'SMTP_Host', 'relay-hosting.secureserver.net', { type: 'string', env: true, i18nLabel: 'Host' }
		@add 'SMTP_Port', '25', { type: 'string', env: true, i18nLabel: 'Port' }
		@add 'SMTP_Username', 'contact@metaproengg.com', { type: 'string', env: true, i18nLabel: 'Username' }
		@add 'SMTP_Password', 'ankurmetapro', { type: 'password', env: true, i18nLabel: 'Password' }
		@add 'From_Email', 'deep.yadav6094@gmail.com', { type: 'string', placeholder: 'email@domain' }
		@add 'SMTP_Test_Button', 'sendSMTPTestEmail', { type: 'action', actionText: 'Send_a_test_mail_to_my_user' }

	@section 'Invitation', ->
		@add 'Invitation_Customized', false, { type: 'boolean', i18nLabel: 'Custom' }
		@add 'Invitation_Subject', '', { type: 'string', i18nLabel: 'Subject', enableQuery: { _id: 'Invitation_Customized', value: true }, i18nDefaultQuery: { _id: 'Invitation_Customized', value: false } }
		@add 'Invitation_HTML', '', { type: 'code', code: 'text/html', multiline: true, i18nLabel: 'Body', i18nDescription: 'Invitation_HTML_Description', enableQuery: { _id: 'Invitation_Customized', value: true }, i18nDefaultQuery: { _id: 'Invitation_Customized', value: false } }

	@section 'Registration', ->
		@add 'Accounts_Enrollment_Customized', false, { type: 'boolean', i18nLabel: 'Custom' }
		@add 'Accounts_Enrollment_Email_Subject', '', { type: 'string', i18nLabel: 'Subject', enableQuery: { _id: 'Accounts_Enrollment_Customized', value: true }, i18nDefaultQuery: { _id: 'Accounts_Enrollment_Customized', value: false } }
		@add 'Accounts_Enrollment_Email', '', { type: 'code', code: 'text/html', multiline: true, i18nLabel: 'Body', enableQuery: { _id: 'Accounts_Enrollment_Customized', value: true }, i18nDefaultQuery: { _id: 'Accounts_Enrollment_Customized', value: false } }

	@section 'Registration via Admin', ->
		@add 'Accounts_UserAddedEmail_Customized', false, { type: 'boolean', i18nLabel: 'Custom' }
		@add 'Accounts_UserAddedEmailSubject', '', { type: 'string', i18nLabel: "Subject", enableQuery: { _id: 'Accounts_UserAddedEmail_Customized', value: true }, i18nDefaultQuery: { _id: 'Accounts_UserAddedEmail_Customized', value: false } }
		@add 'Accounts_UserAddedEmail', '', { type: 'code', code: 'text/html', multiline: true, i18nLabel: 'Body', i18nDescription: 'Accounts_UserAddedEmail_Description', enableQuery: { _id: 'Accounts_UserAddedEmail_Customized', value: true }, i18nDefaultQuery: { _id: 'Accounts_UserAddedEmail_Customized', value: false } }

	@section 'Admin Offline Notification', ->
		@add 'Admin_Offline_Notification_Email', '', { type: 'string', public: true , i18nLabel: 'Admin_Offline_Notification_Email', value : '<html xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:v="urn:schemas-microsoft-com:vml">
   <head>
      <meta charset="UTF-8">
      <meta content="IE=edge" http-equiv="X-UA-Compatible">
      <meta content="width=device-width,initial-scale=1" name="viewport">
      <title>*|MC:SUBJECT|*</title>
      <style>p{margin:10px 0;padding:0}table{border-collapse:collapse}h1,h2,h3,h4,h5,h6{display:block;margin:0;padding:0}a img,img{border:0;height:auto;outline:0;text-decoration:none}#bodyCell,#bodyTable,body{height:100%;margin:0;padding:0;width:100%}#outlook a{padding:0}img{-ms-interpolation-mode:bicubic}table{mso-table-lspace:0;mso-table-rspace:0}.ReadMsgBody{width:100%}.ExternalClass{width:100%}a,blockquote,li,p,td{mso-line-height-rule:exactly}a[href^=sms],a[href^=tel]{color:inherit;cursor:default;text-decoration:none}a,blockquote,body,li,p,table,td{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}.ExternalClass,.ExternalClass div,.ExternalClass font,.ExternalClass p,.ExternalClass span,.ExternalClass td{line-height:100%}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important;font-size:inherit!important;font-family:inherit!important;font-weight:inherit!important;line-height:inherit!important}#bodyCell{padding:10px}.templateContainer{max-width:600px!important}a.mcnButton{display:block}.mcnImage{vertical-align:bottom}.mcnTextContent{word-break:break-word}.mcnTextContent img{height:auto!important}.mcnDividerBlock{table-layout:fixed!important}#bodyTable,body{background-color:#FAFAFA}#bodyCell{border-top:0}.templateContainer{border:0}h1{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:26px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}h2{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:22px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}h3{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:20px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}h4{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:18px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}#templatePreheader{background-color:#FAFAFA;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:0;padding-top:9px;padding-bottom:9px}#templatePreheader .mcnTextContent,#templatePreheader .mcnTextContent p{color:#656565;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:12px;line-height:150%;text-align:left}#templatePreheader .mcnTextContent a,#templatePreheader .mcnTextContent p a{color:#656565;font-weight:400;text-decoration:underline}#templateHeader{background-color:#FFF;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:0;padding-top:9px;padding-bottom:0}#templateHeader .mcnTextContent,#templateHeader .mcnTextContent p{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:16px;line-height:150%;text-align:left}#templateHeader .mcnTextContent a,#templateHeader .mcnTextContent p a{color:#2BAADF;font-weight:400;text-decoration:underline}#templateBody{background-color:#FFF;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:2px solid #EAEAEA;padding-top:0;padding-bottom:9px}#templateBody .mcnTextContent,#templateBody .mcnTextContent p{color:#656565;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:16px;line-height:150%;text-align:left}#templateBody .mcnTextContent a,#templateBody .mcnTextContent p a{color:#2BAADF;font-weight:400;text-decoration:underline}#templateFooter{background-color:#FAFAFA;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:0;padding-top:9px;padding-bottom:9px}#templateFooter .mcnTextContent,#templateFooter .mcnTextContent p{color:#656565;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:12px;line-height:150%;text-align:center}#templateFooter .mcnTextContent a,#templateFooter .mcnTextContent p a{color:#656565;font-weight:400;text-decoration:underline}@media only screen and (min-width:768px){.templateContainer{width:600px!important}}@media only screen and (max-width:480px){a,blockquote,body,li,p,table,td{-webkit-text-size-adjust:none!important}}@media only screen and (max-width:480px){body{width:100%!important;min-width:100%!important}}@media only screen and (max-width:480px){#bodyCell{padding-top:10px!important}}@media only screen and (max-width:480px){.mcnImage{width:100%!important}}@media only screen and (max-width:480px){.mcnBoxedTextContentContainer,.mcnCaptionBottomContent,.mcnCaptionLeftImageContentContainer,.mcnCaptionLeftTextContentContainer,.mcnCaptionRightImageContentContainer,.mcnCaptionRightTextContentContainer,.mcnCaptionTopContent,.mcnCartContainer,.mcnImageCardLeftTextContentContainer,.mcnImageCardRightTextContentContainer,.mcnImageGroupContentContainer,.mcnRecContentContainer,.mcnTextContentContainer{max-width:100%!important;width:100%!important}}@media only screen and (max-width:480px){.mcnBoxedTextContentContainer{min-width:100%!important}}@media only screen and (max-width:480px){.mcnImageGroupContent{padding:9px!important}}@media only screen and (max-width:480px){.mcnCaptionLeftContentOuter .mcnTextContent,.mcnCaptionRightContentOuter .mcnTextContent{padding-top:9px!important}}@media only screen and (max-width:480px){.mcnCaptionBlockInner .mcnCaptionTopContent:last-child .mcnTextContent,.mcnImageCardTopImageContent{padding-top:18px!important}}@media only screen and (max-width:480px){.mcnImageCardBottomImageContent{padding-bottom:9px!important}}@media only screen and (max-width:480px){.mcnImageGroupBlockInner{padding-top:0!important;padding-bottom:0!important}}@media only screen and (max-width:480px){.mcnImageGroupBlockOuter{padding-top:9px!important;padding-bottom:9px!important}}@media only screen and (max-width:480px){.mcnImageCardLeftImageContent,.mcnImageCardRightImageContent{padding-right:18px!important;padding-bottom:0!important;padding-left:18px!important}}@media only screen and (max-width:480px){.mcpreview-image-uploader{display:none!important;width:100%!important}}@media only screen and (max-width:480px){h1{font-size:22px!important;line-height:125%!important}}@media only screen and (max-width:480px){h2{font-size:20px!important;line-height:125%!important}}@media only screen and (max-width:480px){h3{font-size:18px!important;line-height:125%!important}}@media only screen and (max-width:480px){h4{font-size:16px!important;line-height:150%!important}}@media only screen and (max-width:480px){.mcnBoxedTextContentContainer .mcnTextContent,.mcnBoxedTextContentContainer .mcnTextContent p{font-size:14px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templatePreheader{display:block!important}}@media only screen and (max-width:480px){#templatePreheader .mcnTextContent,#templatePreheader .mcnTextContent p{font-size:14px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templateHeader .mcnTextContent,#templateHeader .mcnTextContent p{font-size:16px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templateBody .mcnTextContent,#templateBody .mcnTextContent p{font-size:16px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templateFooter .mcnTextContent,#templateFooter .mcnTextContent p{font-size:14px!important;line-height:150%!important}}</style>
   </head>
   <body>
      <center>
         <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" height="100%" id="bodyTable">
            <tbody>
               <tr>
                  <td valign="top" id="bodyCell" align="center">
                     <table border="0" cellpadding="0" cellspacing="0" class="templateContainer" width="100%">
                        <tbody>
                           <tr>
                              <td valign="top" id="templatePreheader">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionBlock" width="100%">
                                    <tbody class="mcnCaptionBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnCaptionBlockInner" style="padding:9px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionRightContentOuter" width="100%">
                                                <tbody>
                                                   <tr>
                                                      <td valign="top" class="mcnCaptionRightContentInner" style="padding:0 9px">
                                                         <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionRightImageContentContainer" align="left">
                                                            <tbody>
                                                               <tr>
                                                                  <td valign="top" class="mcnCaptionRightImageContent"><img src="https://driftt.imgix.net/https%3A%2F%2Fs3.amazonaws.com%2Fcustomer-api-avatars-prod%2F25136%2F21a3adec02259a0b10090ab03b4e6b524ecaea43upkk?fit=max&fmt=png&h=200&w=200&s=dd7a20f0f889e1885865035bd88d230a" alt="Ecclesia.chat" class="mcnImage" style="max-width:82px" width="82"></td>
                                                               </tr>
                                                            </tbody>
                                                         </table>
                                                         <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionRightTextContentContainer" width="450" align="right">
                                                            <tbody>
                                                               <tr>
                                                                  <td valign="top" class="mcnTextContent">
                                                                     <table>
                                                                        <tbody>
                                                                           <tr>
                                                                              <td><span style="font-size:18px"><strong><span>[churchName]</span>&nbsp;,A new subscriber has sent you a message</strong></span></td>
                                                                           </tr>
                                                                        </tbody>
                                                                     </table>
                                                                  </td>
                                                               </tr>
                                                            </tbody>
                                                         </table>
                                                      </td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                           <tr>
                              <td valign="top" id="templateHeader">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnTextBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnTextBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnTextBlockInner" style="padding-top: 20px;">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnTextContentContainer" width="100%" style="max-width:100%;min-width:100%" align="left">
                                                <tbody>
                                                   <tr>
                                                      <td valign="top" class="mcnTextContent" style="padding-top:0;padding-right:18px;padding-bottom:9px;padding-left:18px">[chat_message]</td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                           <tr>
                              <td valign="top" id="templateBody">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnButtonBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnButtonBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnButtonBlockInner" style="padding-top:0;padding-right:18px;padding-bottom:18px;padding-left:18px" align="center">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnButtonContentContainer" width="100%" style="border-collapse:separate!important;border-radius:3px;background-color:#0176ff;height: 60px;width: 200px;">
                                                <tbody>
                                                   <tr><td valign="middle" class="mcnButtonContent" style="height: 32%;" trebuchet="" ms",tahoma,helvetica,arial,sans-serif;font-size:16px;padding:15px"align="center"><a href="[siteUrl]" target="_blank" class="mcnButton" style="letter-spacing:normal;line-height:100%;text-align:center;text-decoration:none;color:#FFF;font-family:" trebuchet="" ms",tahoma,helvetica,arial,sans-serif"title="Reply in Ecclesia.chat">Reply in Ecclesia.chat</a></td></tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnTextBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnTextBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnTextBlockInner" style="padding-top:9px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnTextContentContainer" width="100%" style="max-width:100%;min-width:100%" align="left">
                                                <tbody>
                                                   <tr>
                                                      <td valign="top" class="mcnTextContent" style="padding-top:0;padding-right:18px;padding-bottom:9px;padding-left:18px">
                                                         <div style="text-align:left">Inbox &nbsp;: &nbsp;[adminemail]</div>
                                                      </td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                           <tr>
                              <td valign="top" id="templateFooter">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnTextBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnTextBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnTextBlockInner" style="padding-top:9px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnTextContentContainer" width="100%" style="max-width:100%;min-width:100%" align="left">
                                                <tbody>
                                                   <tr>
                                                       <td valign="top" class="mcnTextContent" style="padding-top:0;padding-right:18px;padding-bottom:9px;padding-left:18px"><img src="https://driftt.imgix.net/https%3A%2F%2Fs3.amazonaws.com%2Fcustomer-api-avatars-prod%2F25136%2F21a3adec02259a0b10090ab03b4e6b524ecaea43upkk?fit=max&fmt=png&h=200&w=200&s=dd7a20f0f889e1885865035bd88d230a" style=" height:22px !important">&nbsp;<span> Ecclesia.chat </span></td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnDividerBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnDividerBlockOuter">
                                       <tr>
                                          <td class="mcnDividerBlockInner" style="min-width:100%;padding:10px 18px 25px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnDividerContent" width="100%" style="min-width:100%;border-top:2px solid #EEE">
                                                <tbody>
                                                   <tr>
                                                      <td><span></span></td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </td>
               </tr>
            </tbody>
         </table>
      </center>
   </body>
</html>'}

	@section 'Guest Offline Notification', ->
		@add 'Guest_Offline_Notification_Email', '', { type: 'string', public: true , i18nLabel: 'Guest_Offline_Notification_Email', value: '<html xmlns="http://www.w3.org/1999/xhtml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:v="urn:schemas-microsoft-com:vml">
   <head>
      <meta charset="UTF-8">
      <meta content="IE=edge" http-equiv="X-UA-Compatible">
      <meta content="width=device-width,initial-scale=1" name="viewport">
      <title>*|MC:SUBJECT|*</title>
      <style>p{margin:10px 0;padding:0}table{border-collapse:collapse}h1,h2,h3,h4,h5,h6{display:block;margin:0;padding:0}a img,img{border:0;height:auto;outline:0;text-decoration:none}#bodyCell,#bodyTable,body{height:100%;margin:0;padding:0;width:100%}#outlook a{padding:0}img{-ms-interpolation-mode:bicubic}table{mso-table-lspace:0;mso-table-rspace:0}.ReadMsgBody{width:100%}.ExternalClass{width:100%}a,blockquote,li,p,td{mso-line-height-rule:exactly}a[href^=sms],a[href^=tel]{color:inherit;cursor:default;text-decoration:none}a,blockquote,body,li,p,table,td{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}.ExternalClass,.ExternalClass div,.ExternalClass font,.ExternalClass p,.ExternalClass span,.ExternalClass td{line-height:100%}a[x-apple-data-detectors]{color:inherit!important;text-decoration:none!important;font-size:inherit!important;font-family:inherit!important;font-weight:inherit!important;line-height:inherit!important}#bodyCell{padding:10px}.templateContainer{max-width:600px!important}a.mcnButton{display:block}.mcnImage{vertical-align:bottom}.mcnTextContent{word-break:break-word}.mcnTextContent img{height:auto!important}.mcnDividerBlock{table-layout:fixed!important}#bodyTable,body{background-color:#FAFAFA}#bodyCell{border-top:0}.templateContainer{border:0}h1{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:26px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}h2{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:22px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}h3{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:20px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}h4{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:18px;font-style:normal;font-weight:700;line-height:125%;letter-spacing:normal;text-align:left}#templatePreheader{background-color:#FAFAFA;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:0;padding-top:9px;padding-bottom:9px}#templatePreheader .mcnTextContent,#templatePreheader .mcnTextContent p{color:#656565;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:12px;line-height:150%;text-align:left}#templatePreheader .mcnTextContent a,#templatePreheader .mcnTextContent p a{color:#656565;font-weight:400;text-decoration:underline}#templateHeader{background-color:#FFF;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:0;padding-top:9px;padding-bottom:0}#templateHeader .mcnTextContent,#templateHeader .mcnTextContent p{color:#202020;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:16px;line-height:150%;text-align:left}#templateHeader .mcnTextContent a,#templateHeader .mcnTextContent p a{color:#2BAADF;font-weight:400;text-decoration:underline}#templateBody{background-color:#FFF;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:2px solid #EAEAEA;padding-top:0;padding-bottom:9px}#templateBody .mcnTextContent,#templateBody .mcnTextContent p{color:#656565;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:16px;line-height:150%;text-align:left}#templateBody .mcnTextContent a,#templateBody .mcnTextContent p a{color:#2BAADF;font-weight:400;text-decoration:underline}#templateFooter{background-color:#FAFAFA;background-image:none;background-repeat:no-repeat;background-position:center;background-size:cover;border-top:0;border-bottom:0;padding-top:9px;padding-bottom:9px}#templateFooter .mcnTextContent,#templateFooter .mcnTextContent p{color:#656565;font-family:"Trebuchet MS",Tahoma,Helvetica,Arial,sans-serif;font-size:12px;line-height:150%;text-align:center}#templateFooter .mcnTextContent a,#templateFooter .mcnTextContent p a{color:#656565;font-weight:400;text-decoration:underline}@media only screen and (min-width:768px){.templateContainer{width:600px!important}}@media only screen and (max-width:480px){a,blockquote,body,li,p,table,td{-webkit-text-size-adjust:none!important}}@media only screen and (max-width:480px){body{width:100%!important;min-width:100%!important}}@media only screen and (max-width:480px){#bodyCell{padding-top:10px!important}}@media only screen and (max-width:480px){.mcnImage{width:100%!important}}@media only screen and (max-width:480px){.mcnBoxedTextContentContainer,.mcnCaptionBottomContent,.mcnCaptionLeftImageContentContainer,.mcnCaptionLeftTextContentContainer,.mcnCaptionRightImageContentContainer,.mcnCaptionRightTextContentContainer,.mcnCaptionTopContent,.mcnCartContainer,.mcnImageCardLeftTextContentContainer,.mcnImageCardRightTextContentContainer,.mcnImageGroupContentContainer,.mcnRecContentContainer,.mcnTextContentContainer{max-width:100%!important;width:100%!important}}@media only screen and (max-width:480px){.mcnBoxedTextContentContainer{min-width:100%!important}}@media only screen and (max-width:480px){.mcnImageGroupContent{padding:9px!important}}@media only screen and (max-width:480px){.mcnCaptionLeftContentOuter .mcnTextContent,.mcnCaptionRightContentOuter .mcnTextContent{padding-top:9px!important}}@media only screen and (max-width:480px){.mcnCaptionBlockInner .mcnCaptionTopContent:last-child .mcnTextContent,.mcnImageCardTopImageContent{padding-top:18px!important}}@media only screen and (max-width:480px){.mcnImageCardBottomImageContent{padding-bottom:9px!important}}@media only screen and (max-width:480px){.mcnImageGroupBlockInner{padding-top:0!important;padding-bottom:0!important}}@media only screen and (max-width:480px){.mcnImageGroupBlockOuter{padding-top:9px!important;padding-bottom:9px!important}}@media only screen and (max-width:480px){.mcnImageCardLeftImageContent,.mcnImageCardRightImageContent{padding-right:18px!important;padding-bottom:0!important;padding-left:18px!important}}@media only screen and (max-width:480px){.mcpreview-image-uploader{display:none!important;width:100%!important}}@media only screen and (max-width:480px){h1{font-size:22px!important;line-height:125%!important}}@media only screen and (max-width:480px){h2{font-size:20px!important;line-height:125%!important}}@media only screen and (max-width:480px){h3{font-size:18px!important;line-height:125%!important}}@media only screen and (max-width:480px){h4{font-size:16px!important;line-height:150%!important}}@media only screen and (max-width:480px){.mcnBoxedTextContentContainer .mcnTextContent,.mcnBoxedTextContentContainer .mcnTextContent p{font-size:14px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templatePreheader{display:block!important}}@media only screen and (max-width:480px){#templatePreheader .mcnTextContent,#templatePreheader .mcnTextContent p{font-size:14px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templateHeader .mcnTextContent,#templateHeader .mcnTextContent p{font-size:16px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templateBody .mcnTextContent,#templateBody .mcnTextContent p{font-size:16px!important;line-height:150%!important}}@media only screen and (max-width:480px){#templateFooter .mcnTextContent,#templateFooter .mcnTextContent p{font-size:14px!important;line-height:150%!important}}</style>
   </head>
   <body>
      <center>
         <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" height="100%" id="bodyTable">
            <tbody>
               <tr>
                  <td valign="top" id="bodyCell" align="center">
                     <table border="0" cellpadding="0" cellspacing="0" class="templateContainer" width="100%">
                        <tbody>
                           <tr>
                              <td valign="top" id="templatePreheader">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionBlock" width="100%">
                                    <tbody class="mcnCaptionBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnCaptionBlockInner" style="padding:9px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionRightContentOuter" width="100%">
                                                <tbody>
                                                   <tr>
                                                      <td valign="top" class="mcnCaptionRightContentInner" style="padding:0 9px">
                                                         <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionRightImageContentContainer" align="left">
                                                            <tbody>
                                                               <tr>
                                                                  <td valign="top" class="mcnCaptionRightImageContent"><img src="https://driftt.imgix.net/https%3A%2F%2Fs3.amazonaws.com%2Fcustomer-api-avatars-prod%2F25136%2F21a3adec02259a0b10090ab03b4e6b524ecaea43upkk?fit=max&fmt=png&h=200&w=200&s=dd7a20f0f889e1885865035bd88d230a" alt="Ecclesia.chat" class="mcnImage" style="max-width:82px" width="82"></td>
                                                               </tr>
                                                            </tbody>
                                                         </table>
                                                         <table border="0" cellpadding="0" cellspacing="0" class="mcnCaptionRightTextContentContainer" width="450" align="right">
                                                            <tbody>
                                                               <tr>
                                                                  <td valign="top" class="mcnTextContent">
                                                                     <table>
                                                                        <tbody>
                                                                           <tr>
                                                                              <td><span style="font-size:18px"><strong><span>[churchAdminName]</span>&nbsp;from <span>[churchName]</span>&nbsp;replied to your message</strong></span></td>
                                                                           </tr>
                                                                        </tbody>
                                                                     </table>
                                                                  </td>
                                                               </tr>
                                                            </tbody>
                                                         </table>
                                                      </td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                           <tr>
                              <td valign="top" id="templateHeader">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnTextBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnTextBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnTextBlockInner" style="padding-top: 20px;">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnTextContentContainer" width="100%" style="max-width:100%;min-width:100%" align="left">
                                                <tbody>
                                                   <tr>
                                                      <td valign="top" class="mcnTextContent" style="padding-top:0;padding-right:18px;padding-bottom:9px;padding-left:18px">[churchAdminName]</td>
                                                      <td valign="top" class="mcnTextContent" style="padding-top:0;padding-right:18px;padding-bottom:9px;padding-left:18px;text-align:right">[dateTime]&nbsp;[churchURL]</td>
                                                   </tr>
                                                   <tr>
                                                      <td valign="top" class="mcnTextContent" style="padding-top:0;padding-right:18px;padding-bottom:9px;padding-left:18px">[chat_message]</td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                           <tr>
                              <td valign="top" id="templateBody">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnButtonBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnButtonBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnButtonBlockInner" style="padding-top:0;padding-right:18px;padding-bottom:18px;padding-left:18px" align="center">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnButtonContentContainer" width="100%" style="border-collapse:separate!important;border-radius:3px;background-color:#0176ff;height: 60px;width: 200px;">
                                                <tbody>
                                                   <tr><td valign="middle" class="mcnButtonContent" style="height: 32%;" trebuchet="" ms",tahoma,helvetica,arial,sans-serif;font-size:16px;padding:15px"align="center"><a href="[churchURL]" target="_blank" class="mcnButton" style="letter-spacing:normal;line-height:100%;text-align:center;text-decoration:none;color:#FFF;font-family:" trebuchet="" ms",tahoma,helvetica,arial,sans-serif"title="Reply in Ecclesia.chat">Reply</a></td></tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnTextBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnTextBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnTextBlockInner" style="padding-top:9px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnTextContentContainer" width="100%" style="max-width:100%;min-width:100%" align="left">
                                                <tbody>
                                                   <tr>
                                                      <td valign="top" class="mcnTextContent" style="padding-top:20px;padding-right:18px;padding-bottom:20px;padding-left:18px">

                                                         <div style="text-align:left">Inbox &nbsp;: &nbsp;[email]</div>
                                                      </td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                           <tr>
                              <td valign="top" id="templateFooter">
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnTextBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnTextBlockOuter">
                                       <tr>
                                          <td valign="top" class="mcnTextBlockInner" style="padding-top:9px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnTextContentContainer" width="100%" style="max-width:100%;min-width:100%" align="left">
                                                <tbody>
                                                   <tr>
                                                      <td valign="top" class="mcnTextContent" style="padding-top:0;padding-right:18px;padding-bottom:9px;padding-left:18px"><img src="https://driftt.imgix.net/https%3A%2F%2Fs3.amazonaws.com%2Fcustomer-api-avatars-prod%2F25136%2F21a3adec02259a0b10090ab03b4e6b524ecaea43upkk?fit=max&fmt=png&h=200&w=200&s=dd7a20f0f889e1885865035bd88d230a" style=" height:22px !important">&nbsp;<span> Ecclesia.chat </span></td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                                 <table border="0" cellpadding="0" cellspacing="0" class="mcnDividerBlock" width="100%" style="min-width:100%">
                                    <tbody class="mcnDividerBlockOuter">
                                       <tr>
                                          <td class="mcnDividerBlockInner" style="min-width:100%;padding:10px 18px 25px">
                                             <table border="0" cellpadding="0" cellspacing="0" class="mcnDividerContent" width="100%" style="min-width:100%;border-top:2px solid #EEE">
                                                <tbody>
                                                   <tr>
                                                      <td><span></span></td>
                                                   </tr>
                                                </tbody>
                                             </table>
                                          </td>
                                       </tr>
                                    </tbody>
                                 </table>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </td>
               </tr>
            </tbody>
         </table>
      </center>
   </body>
</html>' }

RocketChat.settings.addGroup 'Message', ->
	@add 'Message_AllowEditing', true, { type: 'boolean', public: true }
	@add 'Message_AllowEditing_BlockEditInMinutes', 0, { type: 'int', public: true, i18nDescription: 'Message_AllowEditing_BlockEditInMinutesDescription' }
	@add 'Message_AllowDeleting', true, { type: 'boolean', public: true }
	@add 'Message_AllowDeleting_BlockDeleteInMinutes', 0, { type: 'int', public: true, i18nDescription: 'Message_AllowDeleting_BlockDeleteInMinutes' }
	@add 'Message_AllowUnrecognizedSlashCommand', false, { type: 'boolean', public: true}
	@add 'Message_AlwaysSearchRegExp', false, { type: 'boolean' }
	@add 'Message_ShowEditedStatus', true, { type: 'boolean', public: true }
	@add 'Message_ShowDeletedStatus', false, { type: 'boolean', public: true }
	@add 'Message_AllowBadWordsFilter', false, { type: 'boolean', public: true}
	@add 'Message_BadWordsFilterList', '', {type: 'string', public: true}
	@add 'Message_KeepHistory', false, { type: 'boolean', public: true }
	@add 'Message_MaxAll', 0, { type: 'int', public: true }
	@add 'Message_MaxAllowedSize', 5000, { type: 'int', public: true }
	@add 'Message_ShowFormattingTips', true, { type: 'boolean', public: true }
	@add 'Message_SetNameToAliasEnabled', false, { type: 'boolean', public: false, i18nDescription: 'Message_SetNameToAliasEnabled_Description' }
	@add 'Message_AudioRecorderEnabled', true, { type: 'boolean', public: true, i18nDescription: 'Message_AudioRecorderEnabledDescription' }
	@add 'Message_GroupingPeriod', 300, { type: 'int', public: true, i18nDescription: 'Message_GroupingPeriodDescription' }
	@add 'API_Embed', true, { type: 'boolean', public: true }
	@add 'API_EmbedCacheExpirationDays', 30, { type: 'int', public: false }
	@add 'API_Embed_clear_cache_now', 'OEmbedCacheCleanup', { type: 'action', actionText: 'clear', i18nLabel: 'clear_cache_now' }
	@add 'API_EmbedDisabledFor', '', { type: 'string', public: true, i18nDescription: 'API_EmbedDisabledFor_Description' }
	@add 'API_EmbedIgnoredHosts', 'localhost, 127.0.0.1, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16', { type: 'string', i18nDescription: 'API_EmbedIgnoredHosts_Description' }
	@add 'API_EmbedSafePorts', '80, 443', { type: 'string' }
	@add 'Message_TimeFormat', 'LT', { type: 'string', public: true, i18nDescription: 'Message_TimeFormat_Description' }
	@add 'Message_DateFormat', 'LL', { type: 'string', public: true, i18nDescription: 'Message_DateFormat_Description' }
	@add 'Message_HideType_uj', false, { type: 'boolean', public: true }
	@add 'Message_HideType_ul', false, { type: 'boolean', public: true }
	@add 'Message_HideType_ru', false, { type: 'boolean', public: true }
	@add 'Message_HideType_au', false, { type: 'boolean', public: true }
	@add 'Message_HideType_mute_unmute', false, { type: 'boolean', public: true }

RocketChat.settings.addGroup 'Meta', ->
	@add 'Meta_language', '', { type: 'string' }
	@add 'Meta_fb_app_id', '', { type: 'string' }
	@add 'Meta_robots', 'INDEX,FOLLOW', { type: 'string' }
	@add 'Meta_google-site-verification', '', { type: 'string' }
	@add 'Meta_msvalidate01', '', { type: 'string' }
	@add 'Meta_custom', '', { type: 'code', code: 'text/html', multiline: true }


RocketChat.settings.addGroup 'Push', ->
	@add 'Push_enable', true, { type: 'boolean', public: true }
	@add 'Push_debug', false, { type: 'boolean', public: true, enableQuery: { _id: 'Push_enable', value: true } }
	@add 'Push_enable_gateway', true, { type: 'boolean', enableQuery: { _id: 'Push_enable', value: true } }
	@add 'Push_gateway', 'https://gateway.rocket.chat', { type: 'string', enableQuery: [{ _id: 'Push_enable', value: true }, { _id: 'Push_enable_gateway', value: true }] }
	@add 'Push_production', true, { type: 'boolean', public: true, enableQuery: [{ _id: 'Push_enable', value: true }, { _id: 'Push_enable_gateway', value: false }] }
	@add 'Push_test_push', 'push_test', { type: 'action', actionText: 'Send_a_test_push_to_my_user', enableQuery: { _id: 'Push_enable', value: true } }

	@section 'Certificates_and_Keys', ->
		@add 'Push_apn_passphrase', '', { type: 'string' }
		@add 'Push_apn_key', '', { type: 'string', multiline: true }
		@add 'Push_apn_cert', '', { type: 'string', multiline: true }
		@add 'Push_apn_dev_passphrase', '', { type: 'string' }
		@add 'Push_apn_dev_key', '', { type: 'string', multiline: true }
		@add 'Push_apn_dev_cert', '', { type: 'string', multiline: true }
		@add 'Push_gcm_api_key', '', { type: 'string' }
		@add 'Push_gcm_project_number', '', { type: 'string', public: true }

	@section 'Privacy', ->
		@add 'Push_show_username_room', true, { type: 'boolean', public: true }
		@add 'Push_show_message', true, { type: 'boolean', public: true }


RocketChat.settings.addGroup 'Layout', ->

	@section 'Content', ->
		@add 'Layout_Home_Title', 'Home', { type: 'string', public: true }
		@add 'Layout_Home_Body', 'Welcome to Rocket.Chat <br> Go to APP SETTINGS -> Layout to customize this intro.', { type: 'code', code: 'text/html', multiline: true, public: true }
		@add 'Layout_Terms_of_Service', 'Terms of Service <br> Go to APP SETTINGS -> Layout to customize this page.', { type: 'code', code: 'text/html', multiline: true, public: true }
		@add 'Layout_Login_Terms', 'By proceeding you are agreeing to our <a href="/terms-of-service">Terms of Service</a> and <a href="/privacy-policy">Privacy Policy</a>.', { type: 'string', multiline: true, public: true }
		@add 'Layout_Privacy_Policy', 'Privacy Policy <br> Go to APP SETTINGS -> Layout to customize this page.', { type: 'code', code: 'text/html', multiline: true, public: true }
		@add 'Layout_Sidenav_Footer', '<img style="left: 10px; position: absolute;" src="/assets/logo.png" />', { type: 'code', code: 'text/html', public: true, i18nDescription: 'Layout_Sidenav_Footer_description' }

	@section 'Custom Scripts', ->
		@add 'Custom_Script_Logged_Out', '//Add your script', { type: 'code', multiline: true, public: true }
		@add 'Custom_Script_Logged_In', '//Add your script', { type: 'code', multiline: true, public: true }

	@section 'User Interface', ->
		@add 'UI_DisplayRoles', true, { type: 'boolean', public: true }
		@add 'UI_Merge_Channels_Groups', true, { type: 'boolean', public: true }


RocketChat.settings.addGroup 'Logs', ->
	@add 'Log_Level', '0', { type: 'select', values: [ { key: '0', i18nLabel: '0_Errors_Only' }, { key: '1', i18nLabel: '1_Errors_and_Information' }, { key: '2', i18nLabel: '2_Erros_Information_and_Debug' } ] , public: true }
	@add 'Log_Package', false, { type: 'boolean', public: true }
	@add 'Log_File', false, { type: 'boolean', public: true }
	@add 'Log_View_Limit', 1000, { type: 'int' }


RocketChat.settings.init()

# # Remove runtime settings (non-persistent)
# Meteor.startup ->
# 	RocketChat.models.Settings.update({ ts: { $lt: RocketChat.settings.ts }, persistent: { $ne: true } }, { $set: { hidden: true } }, { multi: true })
