# Windows安装

本文仅介绍Windows vista之后的版本，Windows Xp及之前的版本请在虚拟机中挂载ISO安装。

## Windows安装镜像结构

    boot（BIOS启动需要的文件）
        fonts（字体文件）
            （以下两个字体为BIOS引导的多启动菜单使用中文的必备字体）
            chs_boot.ttf（中文字体）
            wgl4_boot.ttf（拉丁文字体）
            （以下几个字体在Windows8中引入，可能是BOOTMGR蓝屏时使用的）
            msyh_boot.ttf(微软雅黑)
            msyh_console.ttf(微软雅黑)
            msyhn_boot.ttf(微软雅黑)
            segmono_boot.ttf（拉丁文字体）
            segoe_slboot.ttf（拉丁文字体）
            segoen_slboot.ttf（拉丁文字体）
            …….ttf（其他字体，重要程度较低，但没必要删除）
        resources(windows 8加入)
            bootres.dll（BIOS引导Windows8起蓝色窗户转圈圈的动画资源）
        zh-cn（语言文件）
            bootsect.exe.mui（对应程序的语言文件，默认只有这一个文件）
            memtest.exe.mui（对应程序的语言文件，默认没有）
            bootmgr.exe.mui（对应程序的语言文件，默认没有）
        bcd(boot configration data,启动配置数据，BIOS启动必备)
        boot.sdi（内存盘镜像，PE启动所必需的文件,内部有一个NTFS卷，位置在bcd中指定，BIOS启动必备）
        bootfix.bin（按任意键启动DVD/CD的提示“Press any key to boot from CD ...”，删掉会直接进入光盘/U盘）
        bootsect.exe(安装NTLDR（NT5.2)或BOOTMGR（NT6.0）的MBR，以使用不同的启动器）
        etfsboot.com（El Torito 引导扇区文件，用微软官方工具oscdimg生成可引导光盘ISO时使用，支持的光盘格式为ISO 9660 DVD）
        memtest.exe（MBR下内存检查使用的文件）
    efi（EFI启动文件）
        boot
            bootx64.efi（UEFI默认启动文件，会启动bootmgr.efi）
        microsoft
            boot
                fonts（同/boot/fonts）
                resources（同/boot/resources）
                bcd(boot configration data,启动配置数据，内部数据与/boot/bcd不通用)
                cdboot.efi（用于UDF格式光盘，可以加载bootmgr.efi）
                cdboot_noprompt.efi（用于UDF格式光盘，没有“Press any key to boot from CD ...”，会加载bootmgr.efi）
                efisys.bin（用微软官方工具oscdimg生成可引导光盘ISO时使用，支持的光盘格式为ISO 9660 DVD，会加载bootmgr.efi，是一个FAT文件系统软盘镜像）
                efisys_noprompt.bin（用微软官方工具oscdimg生成可引导光盘ISO时使用，支持的光盘格式为ISO 9660 DVD，会加载bootmgr.efi，是一个文件系统软盘镜像）
                memtest.efi（内存测试，似乎不支持语言包）
    sources（安装文件）
        install.wim（系统映像，含有多个版本的映像，也可能是install.esd）
        boot.wim（PE映像，映像1是光盘/U盘版，映像2是硬盘版）
        setup.exe（安装程序UI主文件）
        setuphost.exe（安装后台任务主程序）
        dism.exe（DISM 映像服务实用程序，用于解压系统和PE映像）
        gatherosstate.exe（Gather Downlevel OS Activation State，在从Windows7、Windows8.1升级前会上传激活信息并取得对应版本的Windows10数字权利激活）
        sxs
            内部有.NET3.5的安装cab文件
        （其他文件）
    support（别的文件）
    autorun.inf（自动运行）
    bootmgr（引导加载器，BIOS启动使用，需要引导扇区载入）
    bootmgr.efi（引导加载器主体部分，UEFI启动时使用，但不是UEFI应用，需要bootx64.efi，cdboot.efi，cdboot_noprompt.efi载入）
    setup.exe（在Windows升级时使用的程序，会启动/sources/setup.exe）

关于efisys.bin:由于光盘文件系统CDFS与UDF都不是UEFI标准中可以使用的ESP分区,因此有的主板(很少)不支持从光盘启动,微软为了解决问题,在其官方光盘中存放了两个分区,一个是大的UDF分区,一个是很小的只有/efi/boot/bootx64.efi这一个文件的FAT分区,这个文件会被这些主板加载,文件含有UDF文件系统驱动,会加载bootmgr.efi.如果主板支持UDF分区，则会启动UDF下的/efi/boot/bootx64.efi，同样加载bootmgr.efi．由于U盘启动不需要这么做,因此可以删掉bootmgr.efi、cdboot.efi、cdboot_noprompt.efi、efisys.bin、efisys_noprompt.bin，并使用7zip打开install.wim，找到1\Windows\Boot\EFI\bootmgfw.efi,解压出来重命名为BOOTX64.EFI，替换/EFI/BOOT/BOOTX64.EFI

### 关于wim与esd

Windows 映像文件格式（wim）是一个基于文件的磁盘映像格式。它由微软公司设计且发布于Windows Vista及其之后的Windows操作系统中，用来支持他们的一部分标准安装过程。编辑处理wim的工具为DISM与ImageX（已经被微软抛弃），还有第三方软件DISM++与库wimlib。wim文件可以被挂载到文件夹，这样就可以在不解压wim的情况下直接读取并修改wim内部的文件，就行已经被解压了一样。

电子软件下载文件（ESD）是微软在开发Windows10时推出的文件格式，仅用于推送Windows大版本更新，没有官方工具可以更改ESD文件，也不能像wim文件一样被挂载，而且官方的ESD文件含有加密，虽然密钥每次很快就被发现。ESD压缩比例极高，以Windows10 1607 x64版为例，一个完整的ISO安装映像有4GB，安装完的系统有14GB，但ESD文件仅2.7GB。微软于RS2引入UUP更新，将整个ESD文件分为几十个部分，用户只需要下载需要的部分，在本机上又能组装称完整的安装映像，有效的减小了下载数据量。DISM++与库wimlib可以压缩、解压、解密ESD文件。

[DSIM++下载](http://www.chuyu.me/zh-Hans/)

## 下载Windows10

ms.hit.edu.cn的Windows10版本太老了，不建议使用。

### 微软官网：媒体创建工具

[媒体创建工具下载页面](https://www.microsoft.com/zh-cn/software-download/windows10)

媒体创建工具可以选择升级此电脑，生成ISO文件或制作U盘安装工具。制作U盘安装工具时需要U盘容量大于8GB,且需要格式化U盘。

媒体创建工具尽量下载新版，因为旧版的创建工具不能下载新版的Windows。

### 微软直链下载

以下网站由俄罗斯大神开发，能从微软的服务器上直接获取下载链接，链接24小时有效。

[正式版](https://tb.rg-adguard.net/index.php)

Windows （Final）和 ESD - Electronic Software Download 都可以下载到Windows，但推荐使用ESD，因为一个ESD可以包含多个版本（edition），且通常体积较小。ESD文件需要转换成ISO文件，可以通过DISM++进行。下载地址见前文。

[insider preview与没有正式推送的版本](https://uup.rg-adguard.net/index.php)

在网页上选择需要的系统版本（version），语言和版本（edition），在标明的过期时间内下完即可，过期后刷新网页重新获取。

这种版本需要把列表中所有文件都下载下来，All links for your case:提供了文件列表，支持批量下载的下载器可以使用。下载完成后将File renaming:下的文字保存为bat文件（如rename.bat)放置在下载目录，双击执行，文件即被重命名。随后有校验SHA-1 checksums:请一定校验。随后打开convert-UUP，指定文件保存的目录，然后选择获取install.wim还是整个ISO文件，随后就能得到目标文件。

大家也可以通过uup downloader下载，和网站uup.rg-adguard.net原理一样,但使用本地php网站下载，全自动搜索下载校验。工具见UUP.7z,[源码](https://gitlab.com/uup-dump)

### MSDN版

[MSDN I tell you](https://msdn.itellyou.cn/)

MSDN是微软开发者中心的意思，MSDN订阅用户可以获得微软的操作系统、工具的KEY与镜像，MSDN I Tell You的站长下载这些镜像然后分享电骡链接。

目前最新版的Windows下载链接为

    ed2k://|file|en_windows_10_multiple_editions_version_1703_updated_july_2017_x64_dvd_10925340.iso|5506344960|42868374776644D69C572514DB8116DD|/

    文件名
        en_windows_10_multiple_editions_version_1703_updated_july_2017_x64_dvd_10925340.iso
    SHA1
        1486EC12B04D7B44BB6CB7D1D2AE52A94C891A10
    文件大小
        5.13GB
    发布时间
        2017-07-27

注意，MSDN版只含家庭版与专业版，不含家庭中文版。重装正版家庭中文版不能使用这个镜像。

## 升级到Windows

Windows 7、Windows 8.1、老版本Windows10可以升级到新版的Windows10。32位的操作系统只能升级到32位的Windows10.升级的版本必须符合下表，否则不能获得激活。虽然Windows10的免费升级获得已经结束，但升级操作仍然可以获得数字权利（永久激活）。请注意，中文版/家庭中文版不同于家庭版。

升级时可以选择保留文件和程序、只保留文件或删除全部。某些时候无法保留程序，例如降级或版本不符合以下规定。

<table class="table-bordered"><tbody><tr><th width="50%"><strong>您当前的 Windows 版本</strong></th><th><strong>Windows 10 版本</strong><br>
</th></tr><tr><td>
Windows 7 简易版
<br>Windows 7 家庭普通版
<br>Windows 7 家庭高级版
<br>Windows 8/8.1
<br>Windows 8.1 (含必应)
<br>Windows 10 家庭版
</td><td>Windows 10 家庭版</td></tr><tr><td>
Windows 7 专业版
<br>Windows 7 旗舰版
<br>Windows 8 专业版
<br>Windows 8.1 专业版
<br>Windows 8/8.1 专业版 (含 Media Center)
<br>Windows 10 专业版
</td><td>Windows 10 专业版</td></tr><tr><td>
Windows 8/8.1 单语言版
<br>Windows 8 单语言版 (含必应)
</td><td>Windows 10 家庭单语言版</td></tr><tr><td>
Windows 8/8.1 中文版
<br>Windows 8 中文版 (含必应)
</td><td>Windows 10 家庭中文版</td></tr><tr><td>Windows 10 家庭版</td><td>Windows 10 家庭版</td></tr><tr><td>Windows 10 专业版</td><td>Windows 10 专业版</td></tr></tbody></table>

升级只要在要升级的系统中挂载ISO文件，启动光盘根目录下的setup.exe即可。

Windows7不能直接挂载ISO文件，可以使用第三方工具（如ULTRAISO，Imdisk）挂载或使用解压工具解压到硬盘根目录。Windows8或Windows10可以直接双击挂载ISO，如果文件关联被修改，使用文件管理器打开即可。

升级过程中会占用C盘20G左右的容量，建议C盘至少25G可用空间。

升级到当前使用的版本（即重新安装）是可行的，可能会修复一些系统问题，如系统文件丢失或二进制损坏。如果选择不保留应用，则修复系统的可能性更大。

### 技术细节

setup.exe运行后，会创建$windows.~BT文件夹，内部包含了升级需要的文件。开始升级前，安装程序会确认升级的版本与系统版本是否兼容，并下载升级补丁（如果有的话)与驱动程序（如果有的话)，在弹出正在升级Windows10时，程序会将ISO镜像中的文件复制到$windows.~BT，并从\sources\install.wim解压系统到C:\$windows.~BT\NewOS\，随后重启，进入新系统的恢复模式，将新系统的文件移动到C:\,然后将旧系统移入c：\windows.old，配置新系统的注册表，然后重启，进入新系统后从旧系统将文件复制到新系统，并安装驱动，移动注册表项，然后再次重启，然后删除临时文件，压缩Windows.old，最后进入系统。

### 局限

升级必须保证版本相互兼容，即32位到32位，64位到64位，专业版到专业版，家庭版到家庭版或专业版（允许升级，不允许降级），且限定Windows版本（7 sp1，8.1 update 2，10）。此外，如果源操作系统损坏而不能进入，则不能升级。升级不能解决所有系统损坏的问题。

## 重置Windows

重置属于Windows10自带的功能，其入口在设置应用-更新和安全-恢复-重置此电脑或者是高级启动-重置此电脑（高级启动会在系统启动失败三次后自动进入，或者在设置应用-更新和安全-恢复有高级启动按钮），可以选择保留文件但删除程序或删除所有文件和文件或删除所有文件和程序并安全抹除其他分区的文件。此外RS2还新增了全新安装，会保留文件但删除程序，如果系统不是最新的，会先下载最新的系统。

重置系统仍然会使用之前的系统文件，如果系统文件本身损坏，则重置不能修复问题。在系统不能进入高级启动选项时，不能进行重置。

## 全新安装Windows

### 制作安装介质

#### BIOS+U盘

推荐使用方法0。安装与PE统一介质制作见PE一章。

##### 方法0

将ISO文件保存到安装有PE的U盘上。使用PE中的工具安装。此方法能确保安装到正确的分区。

##### 方法1

将ISO中的文件全部复制到U盘一个分区的根目录，确保这个分区格式是FAT32/NTFS/ExFAT中的一种（建议fat32），然后打开bootice，在物理磁盘标签页目标磁盘下拉栏选择你的U盘，点击“主引导记录（M)”按钮，弹出的对话框选择Windows NT 5.x / 6.x MBR 点击安装/配置，弹出的对话框点击windows NT 6.x MBR，弹出“成功更新主引导记录”，关闭后回到主窗口，点击分区引导记录（P），目标分区选择解压文件到的分区，下面选择BOOTMGR 引导程序（FAT/FAT32/NTFS/ExFAT），点击安装/配置，弹出的对话框点击确定。弹出“成功更新该分区的PBR！”点确定。安装介质就制造完成了。

建议分区格式为FAT32，这样该启动介质也支持UEFI启动。

如果install.wim大于4GB，则FAT32不能存储这么大的文件，可用把install.wim分解为多个文件。

    DISM /Split-Image /ImageFile:“path_to_image_file” /SWMFile:“path_to_swm” /FileSize:<MB-Size>[/CheckIntegrity]                                                                                                                                                                                       将现有 .wim 文件拆分为多个只读 WIM 拆分文件。使用 /FileSize 为创建的每个文件指定最大大小(兆字节(MB))。    使用 /CheckIntegrity 检测和跟踪 WIM 文件损坏。

##### 方法2

用UltraISO打开镜像文件，菜单栏选择启动-写入硬盘映像，弹出的对话框中，硬盘驱动器选择你的U盘，点击写入。注意，此方法会格式化你的U盘。

该启动介质支持UEFI启动。

##### 方法3

下载媒体创建工具下载页面，选择为另一台电脑创建安装介质（U盘、DVD或ISO文件），选择合适的版本（可以取消勾选“对这台电脑使用推荐的选项”），下一步选择你的U盘，等待下载完成。注意，此方法会格式化你的U盘。

该启动介质支持UEFI启动。

#### UEFI＋U盘

推荐使用方法0。安装与PE统一介质制作见PE一章。

##### 方法 0

将ISO文件保存到安装有PE的U盘上。使用PE中的工具安装。此方法能确保安装到正确的分区。

##### 方法 1

确保U盘一个分区为FAT32，否则格式化U盘（或进行分区）（注意备份文件）为FAT32格式，然后将ISO镜像中的文件全部复制到Ｕ盘这个分区的根目录。

##### 方法　2（不推荐）

用UltraISO打开镜像文件，菜单栏选择启动-写入硬盘映像，弹出的对话框中，硬盘驱动器选择你的U盘，点击写入。注意，此方法会格式化你的U盘。

##### 方法　3（不推荐）

下载媒体创建工具下载页面，选择为另一台电脑创建安装介质（U盘、DVD或ISO文件），选择合适的版本（可以取消勾选“对这台电脑使用推荐的选项”），下一步选择你的U盘，等待下载完成。注意，此方法会格式化你的U盘。

#### 移动硬盘

参考方法0与方法1。

#### 光盘

使用刻录机刻录ISO，使用DVD光驱安装

#### 无法启动的疑难解答

##### 对于BIOS

    1.使用正常的PE启动
    2.请按BIOS制作启动盘的方法1第一段重新使用BootIce写入MBR与PBR

##### 对于UEFI

    1.使用正常的PE启动
    2.使用7zip打开install.wim，找到1\Windows\Boot\EFI\bootmgfw.efi,解压出来重命名为BOOTX64.EFI，替换/EFI/BOOT/BOOTX64.EFI

### 开始安装

#### 安装前对固件的判断

推荐大家安装最新版的Windows10,如非特殊情况(如配置过差,老教授等接受新事物能力较差的人)不建议安装Windows7,永远不建议安装Windows Xp,vista,8(已经停止支持),8.1(界面奇葩,用户很少,微软几乎放弃除安全补丁外的服务支持).

建议使用UEFI引导安装Windows10,尤其是固态硬盘.如果之前的操作系统为BIOS启动,也建议手动转换为GPT磁盘并创建EFI分区（详见分区．ｍｄ）改为UEFI启动.少数预装Windows8甚至Windows7的老电脑(尤其是联想的一些win8电脑)由于兼容性问题不容易安装成功,如果尝试多次无法UEFI引导，可以换回BIOS启动

#### 方法0：使用WinNTSetup

此方法需要您启动到Windows PE 或者计算机上的另一个Windows。有关如何从U盘启动的问题，请参考"修改启动顺序"一章。

打开WinNTSetup，确保标签页是默认的Windows Vista/7/8/10/2008/2012。

点击“选择包含windows安装文件的文件夹”右侧的选择，选择install.wim或已经解密的install.esd。

点击“选择引导驱动器”右侧的选择，选择合适的引导驱动器。一般来讲，工具会自动选择正确的引导驱动器

如果“选择引导驱动器”右侧的三个信号灯为“MBR、BOOTMGR　PBR、BOOT PART”，则为BIOS启动。引导驱动器应该是活动分区，通常是硬盘的第一个分区，通常和系统分区是一个分区，但也有将引导分区于系统分区独立分开的。请打开分区工具，确定活动分区是哪一个。如果没有活动分区，请将硬盘上第一个分区激活。

如果，WinNTSetup标题栏最右侧有" uEFI:( "字样，“选择引导驱动器”右侧的三个信号灯为“GPT、BOOTMGR PBR、EFI PART”，则为UEFI启动。引导驱动器应该是ESP分区（EFI 系统分区）。请打开分区工具，查看哪个分区是ESP分区。如果没有ESP分区，请创建一个ESP分区。

如果有两个以上的硬盘，尽量保证引导驱动器与系统分区同在一个硬盘上（一般都应该在固态硬盘上）。有多系统需求的保证后安装的系统引导分区不变。

点击“安装磁盘的位置”右侧的选择，选择要安装到的系统盘。保证系统盘已经被格式化，如果没有，请备份数据，并点击选择左侧的“F”按钮格式化，文件系统选择NTFS。

其他选项可用不设置。挂载安装驱动器为即安装完系统后，系统盘的盘符是那个，一般选C，除非有多系统的需求。预分配驱动器盘符即保持各磁盘盘符为现在的盘符，一般不用勾选。

点击开始安装。如果在正常操作系统中安装多系统，而不是在PE中操作，请完全关闭杀毒软件。

弹出的对话框不必更改。如果有双系统的，勾上查找并添加已经安装在此电脑的Windows版本。点击确定开始安装。

如果弹出报错，请检查硬盘、U盘及安装镜像是否有错误，是否有杀毒软件、病毒干扰，前面的设置是否正确。

弹出”已完成！，这个阶段的安装完成重新启动后，Sysprep部署阶段将开始“，点重启，并拔掉U盘。如果系统正常进入开箱设置（OOBE），则安装成功。

#### 方法1：使用DISM++安装

打开DISM++，选择菜单-文件-释放映像，选择install.wim的位置，然后选择安装的路径（如C:\），勾上添加引导和格式化，然后点确定。

#### 方法2：使用官方安装。

本方法需要在"制作安装介质"一节中使用方法1-3，并启动到安装介质。有关如何从U盘启动的问题，请参考"修改启动顺序"一章。

#### 方法3：使用DISM安装

本方法需要在"制作安装介质"一节中使用方法1-3，并启动到安装介质。有关如何从U盘启动的问题，请参考"修改启动顺序"一章。请通过主板确定引导是UEFI还是BIOS

    ;打开分区工具，首先要格式化旧系统
    ;可使用DISKPART
    ;确定映像信息
    DISM.exe /Get-ImageInfo /ImageFile:F:\sources\install.esd
    >>
    部署映像服务和管理工具
    版本: 10.0.16299.15

    映像详细信息: F:\sources\install.esd

    索引: 1
    名称: Windows 10 Pro
    描述: Windows 10 Pro
    大小: 15,828,729,618 字节

    索引: 2
    名称: Windows 10 Home
    描述: Windows 10 Home
    大小: 15,653,296,691 字节

    索引: 3
    名称: Windows 10 Home China
    描述: Windows 10 Home China
    大小: 15,493,309,133 字节

    索引: 4
    名称: Windows 10 Home Single Language
    描述: Windows 10 Home Single Language
    大小: 15,651,268,593 字节

    索引: 5
    名称: Windows 10 Education
    描述: Windows 10 Education
    大小: 15,647,357,226 字节

    操作成功完成。

    ;应用映像。假如我们安装专业版（PRO）到C:\

    DISM.exe /Apply-Image /ImageFile:F:\sources\install.esd /Index:1 /ApplyDir:C:\
    ;如果是拆分后的映像
    ;DISM.exe /Apply-Image /ImageFile:F:\sources\install.swm /SWMFile:install*.swm /ApplyDir:C:\ /Index:1
    >>
    部署映像服务和管理工具
    版本: 10.0.16299.15

    正在应用映像
    [========================100.0%========================]
    操作完成

    ;安装引导
    >bcdboot /help
    >>
    Bcdboot - Bcd 启动文件创建和修复工具。
    bcdboot.exe 命令行工具用于将关键启动文件复制到系统分区以及创建新的系统 BCD 存储。
    bcdboot <source> [/l <locale>] [/s <volume-letter> [/f <firmware>]] [/v] [/m [{OS Loader ID}]] [/addlast] [/p] [/c]

    source     指定 Windows 系统根目录的位置。
    /l         指定在初始化 BCD 存储时使用的可选区域设置参数。默认值为“简体中文”（在简体中文的系统上）。
    /s         指定一个可选的卷号参数，该参数用于指定要将启动环境文件复制到的目标系统分区。默认值为固件所标识的系统分区。
    /v         启用详细模式。
    /m         如果提供了操作系统加载器 GUID，则此选项可以将给定的加载器对象与系统模板合并，以生成可启动条目。否则，只合并全局对象。
    /d         指定应保留现有的默认Windows 启动条目。
    /f         与 /s 命令一起使用，指定目标系统分区的固件类型。<firmware> 的选项是 'UEFI'、'BIOS' 或 'ALL'。
    /addlast   指定 Windows 引导管理器固件条目应该最后添加。默认行为是首先添加它。
    /p         指定 Windows 引导管理器固件条目位置应予以保留。如果条目不存在，则将在第一个位置添加新条目。
    /c         指定不应迁移模板描述的任何现有对象。
    示例: bcdboot c:\windows /l en-us
    bcdboot c:\windows /s h:
    bcdboot c:\windows /s h: /f UEFI
    bcdboot c:\windows /m {d58d10c6-df53-11dc-878f-00064f4f4e08}
    bcdboot c:\windows /d /addlast
    bcdboot c:\windows /p
    > bcdboot c:\windows /l zh-cn
    >>已成功创建启动文件

    ;完成，重启即可