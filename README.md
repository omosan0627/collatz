HW構成法　冬休み特訓レポート2018

注意:
例えば登り口の変域が1-999でかつ奇数のとき、最高峰9232を取るルートのうち、一番長いものは763と765(ともに行程数152)と
2つあるので、最高峰9232のルート名は一意に定まりません。

このように最高峰が与えられた時、ルート名が一意に定まらない場合がありますが、
少なくともルート4選の最高峰についてはそのようなことは起こらないと仮定の上問題を解くことにします。

方針:

n=4k+3と表せる時、nから2回移動すると6k+5となるので、n'=6k+5と表せるような登り口は考えなくて良いです。
同様にn=8k+1と表せる時、nから3回移動すると、6k+1となります。よってn<1024を満たす時はn'=6k+1と表せるような
登り口は考えなくてよいです。

なので、
n=6k+3 (3,9,...,1023)の171個
n=6k+1 (769,775,...,1021)の43個
計214個の登り口についてのみパスを求めれば良いです。

214<256なので、256個のclimber回路を用意して並列に求めています。214個ではなく256個にした理由は実装が楽になるからです。
全ての回路で登り口からスタートして1に到達したかどうかは、and gateを二分木のようにつなげることで行っています。
(collatz.vhdのdone)

動作の順番としては、
214clocksつかって上の214個の値をcollatz回路にセットする。
->256個のclimber回路がパス長とその最高峰を求める(値がセットされなかった(256-214=)42個climber回路はなんにもしません)
->214clocks使ってルート4選を求める(この時ルート名の一意性を使います)


スペック:

クロック数
467

最大動作周波数(output_files/collatz.sta.rptから取ってきたものです)
+-------------------------------------------------+
; Slow 1100mV 85C Model Fmax Summary              ;
+-----------+-----------------+------------+------+
; Fmax      ; Restricted Fmax ; Clock Name ; Note ;
+-----------+-----------------+------------+------+
; 57.85 MHz ; 57.85 MHz       ; clk        ;      ;
+-----------+-----------------+------------+------+

使用エレメント(output_files/collatz.fit.summaryから取ってきたものです)
Fitter Status : Successful - Sat Jan 12 11:51:18 2019
Quartus Prime Version : 18.1.0 Build 625 09/12/2018 SJ Lite Edition
Revision Name : collatz
Top-level Entity Name : collatz
Family : Cyclone V
Device : 5CGXFC7C7F23C8
Timing Models : Final
Logic utilization (in ALMs) : 31,584 / 56,480 ( 56 % )
Total registers : 18716
Total pins : 177 / 268 ( 66 % )
Total virtual pins : 0
Total block memory bits : 2,560 / 7,024,640 ( < 1 % )
Total RAM Blocks : 1 / 686 ( < 1 % )
Total DSP Blocks : 0 / 156 ( 0 % )
Total HSSI RX PCSs : 0 / 6 ( 0 % )
Total HSSI PMA RX Deserializers : 0 / 6 ( 0 % )
Total HSSI TX PCSs : 0 / 6 ( 0 % )
Total HSSI PMA TX Serializers : 0 / 6 ( 0 % )
Total PLLs : 0 / 13 ( 0 % )
Total DLLs : 0 / 4 ( 0 % )

参考文献
https://github.com/dmingn/HW_report_2017
