import 'package:flutter/material.dart';

import '../../../utils/widget_utils.dart';
/// 隐私协议
class YinsiPage extends StatefulWidget {
  const YinsiPage({Key? key}) : super(key: key);

  @override
  State<YinsiPage> createState() => _YinsiPageState();
}

class _YinsiPageState extends State<YinsiPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('隐私协议', true, context, false, 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: const SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
        child: Text(
          '隐私协议\n'+
              '特别提示\n'+
              '云豹传媒由广州云豹信息科技有限公司及其关联公司（以下简称“我们”或“公司”）提供产品运营和服务。我们深知个人信息对您的重要性，并尽全力保护您的个人信息安全可靠。本政策适用于云豹传媒客户端应用程序、小程序及相关产品服务。\n'+
              '在使用云豹传媒前，请您务必仔细阅读并透彻理解本政策，特别是以粗体/粗体下划线标识的条款，您应重点阅读，在确认充分理解并同意后使用相关产品或服务。\n'+
              '除本隐私政策外，在特定场景下，我们还会通过即时告知（如弹窗、页面提示、消息提醒）、网页公告等方式，向你说明对应的信息收集目的、范围及使用方式，这些即时告知、网页公告等方式构成本隐私政策的一部分，与本隐私政策具有同等效力。\n'+
              '为便于您快速了解《云豹传媒隐私政策》 内容，我们将通过 《云豹传媒隐私政策概要》向您简要、直观地说明我们是如何处理和保护您的个人信息，有关我们对您的个人信息更详细的处理规则，请继续查阅本隐私政策。\n'+
              '下文将帮助您详细了解我们如何收集、使用、存储、传输和保护个人信息；帮助您了解查询、更正、补充、删除、复制个人信息的方式。其中，有关您个人信息权益的重要条款我们已用加粗形式提示，请特别关注。\n'+
              '一、我们如何收集和使用个人信息\n'+
              '二、我们如何使用Cookie等同类技术\n'+
              '三、我们如何共享、转让、公开披露个人信息\n'+
              '四、我们如何存储个人信息\n'+
              '五、我们如何保护个人信息的安全\n'+
              '六、管理您的个人信息\n'+
              '七、未成年人条款\n'+
              '八、隐私政策更新\n'+
              '九、争议解决\n'+
              '十、联系我们\n'+
              '一、我们如何收集和使用个人信息\n'+
              '云豹传媒依据法律法规以及遵循正当、合法、必要的原则而收集和使用您的个人信息。\n'+
              '在您使用我们的产品或服务过程中，我们通常会在以下场景收集和使用您的个人信息。\n'+
              '（一）注册、登录\n'+
              '（1）当您注册、登录云豹传媒账号时，我们会收集您的手机号码和密码，并可能向您发送验证码以验证账号有效性，为注册用户生成云豹账号。请您知悉，我们收集这些信息是为了满足相关法律法规的网络实名制要求，并帮助您生成高效可靠的登录凭证，保护您的账号安全。如果您仅需使用基本的直播、视频浏览服务，您无需注册账号及提供上述信息。\n'+
              '（2）在您登录云豹传媒账号后，如果您愿意自主额外补充头像、昵称、性别、生日、地区、签名、草稿箱、发布的视频等个人资料，将有助于您获得更为具有社交乐趣的体验，如果您不提供前述信息，不会影响您享受云豹传媒的基本功能。如果您仅需要使用浏览功能，您也可以选择在不登录且不提供上述信息的情况下进行。\n'+
              '（二）实名认证\n'+
              '在您使用开通直播、申请提现或其他需要实名认证的功能或服务时，根据国家相关法律法规，您需要向我们和提供认证服务的第三方认证机构提供您的真实身份信息以完成实名认证。主要包括以下几类：\n'+
              '（1）当您申请注册为网络直播服务发布者（主播）时，云豹传媒将根据相关法律规定收集您的真实姓名、身份证件号码进行实名认证，并通过您的面部识别信息进行身份一致性核验。如您选择人工认证方式完成实名认证，我们可能收集您的真实姓名、身份证件信息（包括但不限于身份证件号码、相应证件的正反面图片和您手持相应身份证件的照片）。通过实名认证后，您方可在平台上从事直播发布活动。如果您有主播佣金提现需求，您还需要提供与您身份信息一致的银行卡信息。为了准确验证您的身份，我们将对上述信息进行比对核验。您的真实姓名、身份证件信息、面部识别信息、手持身份证件照片和银行卡信息属于个人敏感信息，我们收集该类信息是基于实名认证要求，您可以拒绝提供，但将可能无法使用实名用户相关服务（如开播、佣金提现），但不影响您正常使用其他功能或服务。\n'+
              '（2）当您参与某些提现活动时，根据相关法规政策要求，我们可能需要收集您的真实姓名、身份证件号码等信息以完成实名认证，具体信息以活动页面公示内容为准。\n'+
              '（三）安全保障\n'+
              '为维护产品或服务的安全稳定运行、识别账号异常、预防恶意程序以及反欺诈目的，我们会收集您以下信息：\n'+
              '（1）网络日志信息，包括账号登录日志、操作时间、操作记录、网络源地址和目标地址、网络源端口、客户端硬件特征、互动发布记录、运行崩溃日志；\n'+
              '（2）您的设备信息，包括：设备型号、操作系统版本、设备标识符（IMEI、AndroidID、OAID、OpenUDID、GUID、SIM卡IMSI信息、IDFA、IDFV）、SIM集成电路卡识别码ICCID、地理位置信息、已安装应用列表、正在运行的进程信息、网络设备硬件地址（MAC地址）、硬件序列号、IP地址、软件版本号、接入网络的方式、类型和状态、网络质量数据、WIFI扫描列表、WIFI名称（SSID）、WIFI MAC地址（BSSID）、蓝牙、设备传感器（如磁力传感器、加速度传感器）所体现的设备特征信息。\n'+
              '上述信息将被用于综合判断账号与交易安全、进行身份验证、识别违规行为和内容、防范安全事件，并采取必要的记录、审计、分析和处置措施。\n'+
              '（四）内容浏览或内容制作\n'+
              '当您浏览直播间内容、web页内容、视频播放器内容，或进行动态发布照片、相机拍摄，我们会调用设备的重力、陀螺仪传感器，以识别您的设备当前的横竖屏状态。\n'+
              '当您浏览AR内容时，我们会调用设备的旋转向量传感器、陀螺仪传感器，以识别您设备在当前的相对握持状态，提供更好的观看体验。\n'+
              '单纯的传感器数据仅为识别设备性能、设备状态，以便提供相关内容浏览或内容制作服务，不涉及任何个人敏感信息。\n'+
              '（五）个性化推荐\n'+
              '为向您展示、推荐您可能感兴趣的直播或音视频内容，提供更适合您的功能或服务，我们会收集和使用您的相关信息，并通过算法模型进行特征与偏好分析，用以向您提供个性化推荐服务。我们可能会因此收集、使用您的如下信息：\n'+
              '（1）您使用云豹传媒时的操作行为信息，包括您在访问/使用云豹传媒时的点击、关注、订阅、搜索、浏览、点赞、评论、发布、分享及打赏交易的操作相关记录，以及您自主填写的性别、生日、地区等个人资料信息；\n'+
              '我们会根据您在使用云豹传媒过程中的操作行为，不断调整优化推荐结果，以便更好地向您提供优质内容。请您知悉，除取得您另行授权或法律法规另有规定外，云豹传媒的个性化推荐机制不会与用户身份信息相结合，以确保不识别到特定自然人的真实身份。\n'+
              '我们为您自主管理个性化推荐机制提供便捷的途径。如您对云豹推送的个性化内容不感兴趣或希望减少某些个性化内容推荐时，可在“推荐”栏目每个静态画面的右下角找到标签按钮，点击该按钮，通过精准屏蔽主播、精准屏蔽分类、“不感兴趣”三种方式管理您的个性化推送内容。\n'+
              '为向您推荐与您相关程度更高的个性化广告，减少无关广告对您的侵扰，我们会根据您使用我们服务的情况，尽可能向您展示您可能更感兴趣、与您更相关的广告。\n'+
              '（六）充值消费\n'+
              '当您使用云豹产品的充值消费功能或通过云豹购买虚拟物品或实物商品及服务时，我们会收集您的充值记录、消费记录、订单信息，以便您查询自己的交易记录，同时尽最大程度保护您的财产、虚拟财产安全。如需进行商品寄送时，您还需要提供收货人姓名、地址、联系电话等信息。拒绝提供这类信息将使您无法使用上述相关功能，但不影响您正常使用其他功能或服务。\n'+
              '（七）客服和申诉\n'+
              '当您向我们的客服或通过产品交互页面发起有关账号安全和未成年人消费相关的申诉或进行咨询时，为了方便与您联系、帮助您解决问题，确保您的账号安全，我们可能需要您提供部分信息或资料，您可以自行决定是否向我们提供，这些资料可能包括您的账号实名信息和账号使用信息，收集这些信息是为了确保您的账号不在被盗或未被授权的情况下发起申诉或咨询，保障您的账号和财产安全。\n'+
              '（八）其他业务功能\n'+
              '8.1调研与推广营销\n'+
              '当您选择参加我们及我们的关联方或第三方举办的有关调查问卷、抽奖中奖、线上或线下推广营销等运营活动时，可能需要您在相关表单中填写姓名、通信地址、联系方式等个人信息。如拒绝提供相关信息，可能会影响您参加相关活动，但不会影响您使用其他功能。只有经过您的同意，我们及第三方才会收集和处理相关信息，以保障为您提供相应的产品服务。具体个人信息处理情况以活动页面公示内容为准。\n'+
              '8.2消息通知\n'+
              '您知悉并同意，我们在运营中可能会通过你在使用产品及/或服务的过程中所提供的联系方式（手机号码），向你同时发送一种或多种类型的通知，例如消息告知、身份验证、安全验证、用户调研；此外，我们也可能会以短信的方式，为你提供你可能感兴趣的服务、功能或活动等商业性信息。但请你放心，如你不愿接受这些信息，你可以通过手机短信中提供的退订方式进行退订，也可以直接与我们联系进行退订。此外，基于平台运营管理需求，我们可能会使用部分平台主播联系方式与其沟通业务运营事宜。\n'+
              '我们会通过你设备的系统通知，向你推送你的订阅开播提醒、订阅用户动态、已预订活动提醒、消息中心提醒、车队召集提醒等，你可选择在设备中关闭云豹的通知功能。\n'+
              '8.3邀请互动、分享互动、福利礼包互动\n'+
              '在您邀请或接受邀请信息、分享或接收被分享的信息、参加福利或礼包活动时，在使用邀请按钮、使用分享按钮、启动云豹传媒APP、点击领取福利或礼包的场景下，云豹传媒客户端需要在本地访问你的剪切板，用于写入、读取其中对应包含的邀请码、分享码、口令、链接，以实现邀请、分享、福利或礼包领取、跳转至用户活动页、活动联动等功能或服务。我们仅在本地识别出剪切板内容属于上述功能或服务有关的指令时才会将其上传我们的服务器。除此之外，云豹传媒客户端不会上传你剪切板的其他信息至我们的服务器。另外，我们可能需要获取存储/相册权限以便于你分享或接收被分享的视频和图片。\n'+
              '8.4直播间互动\n'+
              '您理解并知悉，云豹传媒并非私密空间。当您在云豹传媒间互动时，您的昵称、头像、互动信息（包括但不限于弹幕、评论、送礼等信息）将在直播间内公开展示，同时我们会根据用户的互动活跃情况形成直播间内的统计数据（例如榜单、排名等）并公开展示。\n'+
              '8.5系统权限使用说明\n'+
              '（1）基于相机/摄像头的业务功能。您可在开启相机/摄像头权限后使用云豹的扫描二维码、视频直播和拍摄功能，以及在特定场景下经您授权的人脸识别等功能。当您使用该业务功能进行人脸识别时我们会收集您的面部特征，且严格在经您授权同意的范围内使用，未来如我们拟使用您的面部信息为您提供其他产品及/或服务功能的，我们会再次与您确认。当您通过iOS系统使用云豹传媒的开播组件时，我们可能会使用ARKit和TrueDepth API中的人脸映像深度相关信息的计算结果，用于美颜、特效滤镜、贴纸、虚拟形象等功能以达到更好的人脸处理效果；在此期间，我们既不会将该等运作结果用于其他目的，也不会上传或存储至服务器。\n'+
              '（2）基于相册（图片库/视频库）的图片/视频访问及上传的附加服务。您可以在开启权限后使用相关功能上传您的照片/图片/视频，以实现更换头像、发布动态、上传下载等功能。\n'+
              '（3）基于麦克风语音技术的附加服务。您使用语音转文字功能发送弹幕评论、开直播、使用语音交友功能时，我们会请求您授权麦克风权限并收集您的语音内容。\n'+
              '（4）此外，我们在提供产品或服务的过程中，还可能需要向您申请其他设备权限，您查看并了解云豹传媒申请的权限详情。这些权限均不会默认开启，只有经过您的明示授权才会在为实现特定功能或服务时使用，您可以通过云豹传媒APP，管理您对相关权限的授权。特别需要指出的是，即使经过您的授权，我们获得了这些敏感权限，也不会在相关功能或服务不需要时而收集您的信息。\n'+
              '（九）其他合法性事由\n'+
              '根据法律法规的规定，在下述情形中，我们可能会收集、使用您的个人信息无需征求您的授权同意：\n'+
              '（1）为订立、履行个人作为一方当事人的合同所必需\n'+
              '（2）为履行法定职责或者法定义务所必需（如与国家安全、国防安全、刑事侦查、起诉、审判和判决执行等直接相关的法定职责或者法定义务）；\n'+
              '（3）为应对突发公共卫生事件，或者紧急情况下为保护自然人的生命健康和财产安全所必需；\n'+
              '（4）为公共利益实施新闻报道、舆论监督等行为，在合理的范围内处理个人信息；\n'+
              '（5）依照法律规定在合理的范围内处理您自行公开的个人信息，或者其他已经合法公开的个人信息（如合法的新闻报道、政府信息公开等渠道合法公开的个人信息）；\n'+
              '（6）法律、法规规定的其他情形。\n'+
              '二、我们如何使用Cookie等同类技术\n'+
              'Cookie和设备信息标识等同类技术是互联网中普遍使用的技术。当您使用云豹及相关服务时，我们可能会使用相关技术向您的设备发送一个或多个Cookie或匿名标识符，以收集、标识您访问、使用本产品时的信息。我们承诺，不会将Cookie用于本隐私政策所述目的之外的任何其他用途。我们使用Cookie和同类技术主要为了实现以下功能或服务：\n'+
              '1、保障产品与服务的安全、高效运转\n'+
              '我们可能会设置认证与保障安全性的Cookie或匿名标识符，使我们确认您是否安全登录服务，或者是否遇到盗用、欺诈及其他不法行为。这些技术还会帮助我们改进服务效率，提升登录和响应速度。\n'+
              '2、帮助您获得更轻松的访问体验\n'+
              '使用此类技术可以帮助您省去重复您填写信息、输入搜索内容的步骤和流程。\n'+
              '3、向您推荐您可能感兴趣的直播内容\n'+
              '我们可能会利用此类技术了解您使用云豹服务的偏好和使用习惯，进行数据分析，向您推荐你可能感兴趣的直播内容。\n'+
              '4、Cookie的清除\n'+
              '大多数浏览器均为用户提供了清除浏览器缓存数据的功能，您可以在浏览器设置功能中进行相应的数据清除操作；您也可以管理和清除移动设备上由云豹传媒APP保存的所有cookie（路径：登录云豹传媒APP，进入“我的”→ （设置按钮）→清除缓存）。如您进行清除，您可能无法使用由我们提供的、依赖于Cookie的个性化推荐服务及其他相应功能。\n'+
              '三、我们如何共享、转让、公开披露个人信息\n'+
              '（一）共享\n'+
              '为了向您提供更完善、优质的产品和服务，我们可能会与第三方合作伙伴共享您的某些个人信息。我们严格遵循合法正当、最小必要、确保安全的原则共享您的个人信息。对共享信息的合作方，我们会与其订立专门的数据保护协议，要求其按照我们的说明、本隐私政策以及其他任何相关的保密和安全措施来处理个人信息。您可以通过云豹传媒APP【设置】-【第三方数据共享清单】查阅我们如何与第三方共享您的个人信息。通常我们会在以下场景共享个人信息：\n'+
              '1、与第三方SDK共享：为保障云豹传媒APP相关功能或服务的实现，我们接入了第三方SDK服务。如您在我们平台上使用这类由第三方提供的服务时，您同意将由其收集和处理您的信息（如以嵌入代码、插件等形式）。前述服务商收集和处理个人信息等行为遵守其自身的隐私政策，而不适用于本政策。为了最大程度保障您的信息安全，我们强烈建议您在使用任何第三方SDK类服务前先行查看其隐私政策。为保障您的合法权益，如您发现该等SDK或其他类似的应用程序存在风险时，建议您立即终止相关操作并及时与我们取得联系。您可以查看云豹传媒查看并了解其处理您个人信息的情况。\n'+
              '2、与关联公司共享：为便于我们基于云豹或关联公司的账号向您提供一致化的产品和服务，在云豹或云豹关联公司的多个产品中（例如云豹传媒、云豹嗨玩版、云豹助手、云豹手游、小鹿电竞、yowa云游戏等）方便您使用统一账号注册登录，向您推荐您可能感兴趣的内容和信息，保护云豹或云豹关联公司用户的账号及财产安全，您的账号信息、实名认证信息、设备和日志信息可能会与我们的关联公司共享。我们只会共享必要的个人信息，且受本隐私政策中所声明目的的约束，如果我们变更个人信息使用及处理目的，将再次征求您的授权同意。\n'+
              '3、与授权合作伙伴共享：\n'+
              '（1）基础服务提供商：包括提供实名认证、支付、一键登录、消息推送、地理位置定位、反欺诈的合作方，与这些服务提供商的信息共享大多通过SDK方式进行，具体详见第一部分。\n'+
              '（2）委托我们进行信息推广和广告投放的合作伙伴：您授权我们有权与委托我们进行信息推广和广告投放的合作伙伴共享我们使用您的相关信息形成的无法识别您的个人身份的间接用户画像、设备信息、去标识化或匿名化处理后的分析/统计类信息，以帮助其在不识别您个人身份的前提下进行广告或决策建议、提高广告有效触达率、衡量广告和相关服务的有效性。\n'+
              '（3）提供数据服务（包括网络广告监测、数据统计、数据分析）的合作伙伴：为维护/改进我们的产品/服务、为您提供更好的内容，我们可能会与提供该服务的指定合作伙伴共享您的相关信息（包括：设备信息、广告展示和点击记录、终端型号、地理位置），除非得到您的同意，我们不会与其共享您的个人身份信息。\n'+
              '（4）提供电商服务的合作伙伴：为帮助用户实现购买及商品派送服务，我们可能与电商合作伙伴或服务提供方共享您的昵称、头像等账号信息、订单信息、收件信息（包括收货人姓名、地址、联系电话信息）。相关收件信息也可能会共享给物流服务提供方，以便完成必要的商品配送服务，我们将尽最大努力保证数据安全。\n'+
              '（5）内容安全监测服务提供商：我们可能与特定内容安全监测服务提供商合作进行违规音视频标注和分析，可能会与这些服务提供商共享直播流信息。\n'+
              '（6）提供开播或直播推流服务的合作伙伴：当我们与提供开播或直播推流服务的第三方平台进行合作时，我们可能共享用户昵称、弹幕、评论、排行榜、送礼信息等直播间已公开的用户数据。\n'+
              '（7）提供内容推广服务的合作伙伴：当我们与游戏提供方进行合作时，我们可能共享用户昵称、头像等账号信息、设备信息和游戏订单信息，以便帮助用户实现游戏账号绑定、游戏道具领取等功能（仅当用户主动选择参与活动时），您也可以查阅具体游戏合作方隐私政策进行了解其收集处理个人信息的情况。\n'+
              '（二）转让\n'+
              '我们不会将您的个人信息转让给任何公司、组织和个人，但以下情况除外：\n'+
              '1、您自行提出要求的；\n'+
              '2、事先已征得您的明确授权同意：\n'+
              '3、在云豹公司发生合并、收购或破产清算情形，或其他涉及合并、收购或破产清算情形时，如涉及到个人信息转让，我们会要求新的持有您个人信息的公司、组织继续受本政策的约束，否则我们将要求该公司、组织和个人重新向您征求授权同意。\n'+
              '（三）公开披露\n'+
              '除符合法律法规的规定进行公开披露或获得您单独同意外，我们不会公开披露您未自行公开或者其他未合法公开的个人信息。我们可能会在发布违规处罚公告、公示中奖信息等场景而进行必要的信息披露，同时我们将审慎评估公开披露的合法性、正当性、合理性，采取脱敏、去标识化等安全保护措施保护用户个人信息。\n'+
              '（四）其他合法性事由\n'+
              '根据法律法规的规定，在下述情形中，我们可能会共享、转让、公开披露您的个人信息无需征求您的授权同意：\n'+
              '1)为订立、履行个人作为一方当事人的合同所必需；\n'+
              '2)为履行法定职责或者法定义务所必需（如与国家安全、国防安全、刑事侦查、起诉、审判和判决执行等直接相关的法定职责或者法定义务）；\n'+
              '3)为应对突发公共卫生事件，或者紧急情况下为保护自然人的生命健康和财产安全所必需；\n'+
              '4)为公共利益实施新闻报道、舆论监督等行为，在合理的范围内处理个人信息；\n'+
              '5)依照法律规定在合理的范围内处理您自行公开的个人信息，或者其他已经合法公开的个人信息（如合法的新闻报道、政府信息公开等渠道合法公开的个人信息）；\n'+
              '6) 法律法规规定的其他情形。\n'+
              '四、我们如何存储个人信息\n'+
              '我们在中华人民共和国境内运营中收集和产生的个人信息，存储在中国境内，不会对您的个人信息跨境传输。\n'+
              '我们仅在为提供产品或服务目的所必需且最短的期间内存储您的个人信息。超出期限后，我们将对个人信息进行删除或匿名化处理，但法律法规另有规定的除外。例如：\n'+
              '1、《中华人民共和国网络安全法》第二十一条第三款要求监测、记录网络运行状态、网络安全事件的技术措施的网络日志留存不得少于六个月；\n'+
              '2、《互联网直播服务管理规定》要求记录互联网直播服务使用者发布内容和日志信息，保存六十日；\n'+
              '3、《电子商务法》规定商品和服务信息、交易信息保存时间自交易完成之日起不少于三年；\n'+
              '4、为遵守法院判决、裁定或其他法律程序的规定；\n'+
              '5、为维护社会公共利益，保护公司及关联公司、其他自然人等主体的合法权益所合理必须的用途。\n'+
              '五、我们如何保护个人信息的安全\n'+
              '为保障您的信息安全，我们努力采取各种符合业界标准、合理的物理、电子和管理方面的安全措施来保护您的信息，使您的信息不会被泄漏、毁损或者丢失，包括但不限于部署主机入侵检测系统、重要敏感信息加密存储、数据中心的访问控制、日志记录安全审计。我们对可能接触到您的信息的员工或外包人员也采取了严格管理，包括但不限于根据岗位的不同采取不同的权限控制，与他们签署保密协议，监控他们的操作情况等措施。我们会按现有技术提供相应的安全措施来保护您的信息，提供合理的安全保障，我们将尽力做到使您的信息不被泄漏、毁损或丢失。\n'+
              '您的账户均有安全保护功能，请妥善保管您的账户及密码信息。我们将通过向其它服务器备份、对用户密码进行加密等安全措施确保您的信息不丢失，不被滥用和变造。尽管有前述安全措施，但同时也请您理解在信息网络上不存在“完善的安全措施”。如您发现自己的个人信息泄密，尤其是您的账户及密码发生泄露，请您立即联络我们客服，以便我们采取相应措施。\n'+
              '六、管理您的个人信息\n'+
              '云豹传媒非常重视用户的个人信息权益，并尽全力保障您对自己个人信息享有的各项法定权利，以便您拥有充分的能力保障您的信息安全。\n'+
              '注销账号\n'+
              '您可以通过以下方式注销自己的账号：\n'+
              '1、登录云豹传媒APP，进入“我的”→“设置”→“注销账号”；\n'+
              '2、通过在线客服的指引了解账号的条件并完成账号注销；\n'+
              '3、按照本政策文末所列明的公开联系方式，联系我们协助您注销账号。\n'+
              '在您主动注销账户之后，我们将在十五个工作日内进行处理。账号注销后，我们将停止为您提供与该云豹账号相关联的所有产品和服务，根据适用法律的要求删除您的个人信息或进行匿名化处理，但法律法规另有规定的除外。\n'+
              '请注意，账号注销后您已发布的所有内容（包括提供的音视频、图文等信息）将转为匿名发布，如需删除内容，请在申请注销前自行处理。\n'+
              '（六）访问和要求解释隐私政策\n'+
              '我们将在您首次开启、注册和登录云豹传媒APP时，向您提示本隐私政策并由您自主作出选择同意的决定。另外，您可以通过“设置”→“隐私设置”→“隐私协议”页面随时查看本隐私政策的全部内容。\n'+
              '（七）有权获得停止运营的告知\n'+
              '如果我们停止运营产品或服务，将及时停止继续收集您的个人信息，我们会以公告或逐一送达等形式向你发送停止运营的通知，并在停止服务或运营后对相关个人信息进行删除或匿名化处理，法律法规另有规定的除外。\n'+
              '（八）其他权利\n'+
              '如云豹用户（仅限自然人）不幸逝世，其近亲属为了自身的合法、正当利益，可以对去世用户的相关个人信息行使查阅、复制、更正、删除等权利，但去世用户生前另有安排的除外。\n'+
              '七、未成年人条款\n'+
              '如您为未成年人，我们要求您请您的父母或监护人在仔细阅读本隐私政策，并在征得您的父母或监护人的同意之后，在他们的指导下使用我们的服务。\n'+
              '对于经父母或监护人同意使用我们的产品或服务而收集未成年人个人信息的情况，我们只会在法律法规允许、父母或监护人明确同意或者保护未成年人所必要的情况下使用、共享、转让或披露此信息。如果您认为我们可能不当地持有关于未成年人的信息，请联系我们。\n'+
              '为保护儿童及未成年人的个人信息，我们设立了专门的儿童个人信息保护专职机构，如您对您所监护的儿童的个人信息保护有相关疑问或权利请求时，请通过《云豹儿童个人信息保护指引》中披露的联系方式与我们联系。我们会在合理的时间内处理并回复您。\n'+
              '八、隐私政策更新\n'+
              '1、为给您提供更好的服务以及随着云豹业务的发展，本隐私政策也会随之更新，该等更新构成本隐私政策一部分。但未经您明确同意，我们不会削减您依据本隐私政策所应享有的权利。我们将在更新后的本隐私政策生效前，通过显著位置提示或向您发送推送消息或以其他方式通知您，也请您访问云豹传媒以便及时了解最新的隐私政策。如该等更新造成您在本隐私政策下权利的实质减少或重大变更，我们会再次征求您的明示同意。\n'+
              '您需理解，只有在您确认并同意变更后的《云豹传媒隐私政策》，我们才会依据变更后的隐私政策收集、使用、处理和存储您的个人信息；您有权拒绝同意变更后的隐私政策，但请您知悉，一旦您拒绝同意变更后的隐私政策，可能导致您不能或不能继续完整使用云豹传媒的相关服务和功能，或者无法达到我们拟达到的服务效果。\n'+
              '2、本隐私政策所指的重大变更包括但不限于：\n'+
              '（1）个人信息的处理目的、处理方式和处理的个人信息种类发生变更；\n'+
              '（2）我们在所有权结构、组织架构等方面发生重大变化，如业务调整、破产并购等引起的所有者变更等；\n'+
              '（3）您个人信息权利及其行使方式发生重大变化。\n'+
              '九、争议解决\n'+
              '本隐私政策适用中华人民共和国大陆地区法律。任何因本隐私政策以及我们处理您个人信息事宜引发的争议，首先可友好协商解决；协商不成的，您同意通过向本协议签署地（广东省广州市番禺区）有管辖权的法院提起诉讼来寻求解决方案。\n'+
              '本隐私政策的标题仅为方便及阅读而设，并不影响正文其中任何规定的含义或解释。\n'
          ,
          maxLines: 500,
          style: TextStyle(
            height: 2.0,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
