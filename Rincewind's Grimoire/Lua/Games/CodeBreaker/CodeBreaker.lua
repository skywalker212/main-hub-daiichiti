LuaQ                +   $      $@  @  $�  �  $�  �  $    $@ @ $� � $� � $    $@ @ $� � $� � $    $@ @ $� � $� � $    $@ @ $� � $� � $     �       CodeBreakerStartGame    CodeBreakerStopGame    CodeBreakerQuestion    CodeBreakerQuestionTime    CodeBreakerGuess    CodeBreakerMixPhrase    CodeBreakerSetScores    CodeBreakerReadScoresFromFile    CodeBreakerWriteScoresToFile    CodeBreakerShowScores    CodeBreakerClearScores    CodeBreakerArchiveScores    CodeBreakerMaintainPlayers    CodeBreakerShowArchive    CodeBreakerQuestionPause    CodeBreakerTimeOut    CodeBreakerAutoStart    TriggerCodeBreaker    TriggerCodeBreakerAutoStart    TriggerCodeBreakerQPause    TriggerCodeBreakerTimeOut           )     �   �@  �   ��  ��@ A���@ ��A�� � ��@ �� �@B��� �� �  CEA AA� �@ �� �� �  W D  ��@ ƀ�A �DE� F��A ƁE � A� � �A � �܀ � ����@ ƀ�� �FA� � �A � �܀ � ��  �� ŀ  �@��� ���  EA F��F���	 � B	 �Ł  �A��@��� ǀ	 ��	 �@� ����  EA F��F���A ��D�A Ɓ�B �DE� F��B
 ł
 ���� A �B ��K܁ � EB F��F���� �� �@��  A � ��� @ �B ��H��H�	   AC	 �B��  CGB��  @��  ǀ	 ŀ � E�  F��� N���� �@  � 5      gsFunction    CodeBreakerStartGame    tCodeBreakerSettings    bManualStart            TmrMan    RemoveTimer    tTimers    TriggerCodeBreakerAutoStart  	   RegTimer    TriggerCodeBreakerTimeOut 	   iTimeOut    Minute    sGameInProgress    CodeBreaker        string    gsub    tScriptMessages    sQuizStartedBy    !username!    sNick    !game! 
   gsVersion         sQuizStarted    sCodeBreakerAnswer    jfsighiw reygt8y953g    bPlayInMain       �?   SendMessage    all    tBots    tCodeBreaker    sName    

		    
    iCodeBreakerQuestion    CodeBreakerQuestion    sCodeBreakerStarting 	   !prefix!    tGeneralSettings    sPrefix 
   !command!    tScriptCommands    sCodeBreakerJoin    !bot!    pairs    tCodeBreakerPlayers    TriggerCodeBreakerQPause    iQuestionsPause    Second                     /   N     w   �@  �   �� ���  �@Aŀ ��� EA �� �� U���� ��  ���  �@A�  �@�� CAA ��C ܀  EA �� �� U���� ��  �� �  A �D�@��@ ��D E@��@ �� � FAFA� ��  �� U���A ��D�@��@ �� � FAFE �A ��D�@����@ ŀ �  ��A  �E� F�FB��� ��  � ��B ����A��A  �E� F�FB�� �B ����A���   ��� �   �@��� �@  �@��� ��  �@��@ ��H I@��@	 ��	 � �A AJE�
 AA�	 ܀��� ��  ��  � +      gsFunction    CodeBreakerStopGame    TimeOut 	   sMessage    string    gsub    tScriptMessages    sQuizStopped    !game! 
   gsVersion         sGameInProgress    sQuizStoppedBy    !username!    sNick    CodeBreakerSetScores        tCodeBreakerSettings    iTopScores    bPlayInMain       �?   SendMessage    all    tBots    tCodeBreaker    sName    

		    
    sScoresOutput    pairs    tCodeBreakerPlayers    RemoveTimer    TriggerCodeBreaker    TriggerCodeBreakerQPause    TriggerCodeBreakerTimeOut    bManualStart            tTimers    TriggerCodeBreakerAutoStart    TmrMan 	   AddTimer    iAutoStartDelay    Minute                     T   �      �   @     �  E�  �  �@A@ @�E� F�� �  �@B�� � A �A �\�   � E� ��  �  ���\@�E  F � @� @�E� �� �  �@�ƀ�� @  � �E F�\@�E� �� �  �@�ƀ�A E F�\@���E� �� \  ��� �  BE�EA� �  � U� �D�A��� �  BE�EEB � �D�A�a�   �E  �@ �@ \@�E  �� �@ \@�E  �� �@ \@�E  F � @� @�E� � 	 �@I�  ƀ��	 � �� ���I���C � G@ ��A�  G 
 A�  G@
 A�  G�
 J   G�
 J   G  A�  ��  �@  AKAA �@�Ł ���B E� F�� �BL\ ܁  � �Ł Ɓ� BL@ � ܁ @ ���
 �A �A
  � ���A
 �  �L��
  �A �A��
 � �ŀ ��� MAA � �AK܀ � �AE� F���� ��A� Ɓ�� E�  �� �  BA\� �A ���     D@D@�� A� � �AE��E�   DA���� E�  �E� ��� �B�Ƃ�   E F�\B�!�   �� O�� � A EA � ��O�� ���A A  � @      gsFunction    CodeBreakerQuestion        iCodeBreakerQuestion    tCodeBreakerSettings    iQuestions    string    gsub    tScriptMessages    sQuizFinished    !game! 
   gsVersion         sGameInProgress    CodeBreakerSetScores    iTopScores    bPlayInMain       �?   SendMessage    all    tBots    tCodeBreaker    sName    

		    
    sScoresOutput    pairs    tCodeBreakerPlayers    RemoveTimer    TriggerCodeBreaker    TriggerCodeBreakerQPause    TriggerCodeBreakerTimeOut    bManualStart            tTimers    TriggerCodeBreakerAutoStart    TmrMan 	   AddTimer    iAutoStartDelay    Minute    sCodeBreakerCode    sCodeBreakerAnswer    sCode    tCode 	   tGuessed    iQuestionLength    math    random    len    sAllowedCharacters    sub    sHiddenChar    sQuizCodeBreakerQuestion 	   !length!    sQuizQuestion    !thisquestion!    !totalquestions!    !question!    iQuizStartTime    os    clock 	   RegTimer    iQuestionsTime    Second                     �   �      
6   @     �   A E@ F�� �� �  � �  @ �B �B @�  A@ �� ��C� Dŀ  A �B@���@ E�   �E ��Ł ������  EB F��\A�!�   ��     A@ �� @�� E� �@ � F�@ �� �� @  �       gsFunction    CodeBreakerQuestionTime 	   sMessage    string    gsub    tScriptMessages    sQuizUnanswered 	   !answer!    sCodeBreakerAnswer    tCodeBreakerSettings    bPlayInMain       �?   SendMessage    all    tBots    tCodeBreaker    sName    pairs    tCodeBreakerPlayers )   jdsghihgierhvierhvbjuevierhgoiernborebio    RemoveTimer    TriggerCodeBreaker 	   RegTimer    TriggerCodeBreakerQPause    iQuestionsPause    Second                     �   (    �  �@  �   ��  ��   �@��@ ��  � �AE AA�  �@ �@ ��B� � � � �EA F���� � \�B  @C�� �C A��� A �BD � � �CB���� E� @�EC F��CD \� W@���E� ���C ƃ����DD A � �E� F��\C�!�  ��� BFEB F���� � �B�܂� � ��\��BEB F���� ��G\�� �E � \�  �@H  � EB �� �B �� �BD ���  @��� �BD ���� CD ���������@��� �BD 
 FCD � "C ���	 �BIł	 � FCD C�B���	 �BD C ����	 ���	 ܂ � FCD C�GAC
 ������	 �A����GŃ	 ƃ����M���
 �C� �C ��F��  DG�� E� D����� �C �K�C ��D KED F���� �DD � A ��܃ D E� �� ��
 �� ��C A@��� � D �E�EE�
 �� ��C	�C����� �� � ���  �EE F��
F��
��
 Ņ ƅ��D���   ������C �K�C ƃ�� E�	 �AF��F��� ��
 � ��C �M��
 �C �K�C ��D KED F��D �K	�D ��	�
 A� �ED ܄ E @ �� ��   \� �� � � A ��܃ D @��� ��
 �� ��C A@��� � D �E�EE�
 �� ��C	�C����� �� � ���  �EE F��
F��
��
 Ņ ƅ��D���   ��C
 �� ��  ��  �C��C � � DOE� DA �C �� � �'� @ � W�O��� W@J��B P@ � E� FB�@��B
 AB �B
 � � CPA ���C ƃ�  @ � ܃  ��� ƃ��@�L�� � ���� �� � Q���B�ł Ƃ� �����  FCD � Ń ƃ��B���ł � �@�D EFDD � W ��� @ �D ��E	��E	�DD  @ �D�	� �C
D��  ���B ��C KEC F��C �CQ�� DD \� �� ��� A � ܂ ��
 ł Ƃ� �@���  EC F��F����
 Ń ƃ��B���ł � � �� @ �D ��E	��E	��
 � �C
D��   ��� � ��� �C@H��� E� @�EC F��CD \� W@���E� ���C ƃ����DD A� � �E� F��\C�!�  ��B   � H      gsFunction    CodeBreakerGuess    RemoveTimer    TriggerCodeBreakerTimeOut       �?	   RegTimer    tCodeBreakerSettings 	   iTimeOut    Minute    string    find    %b<>%s+(.*)    %$To:    sCodeBreakerAnswer    bPlayInMain    SendMessage    all    sNick    pairs    tCodeBreakerPlayers    lower    tBots    tCodeBreaker    sName    ^    iQuestionsTime    format    %.0f    os    clock    iQuizStartTime        @	   tonumber         5   456dsgfsdgdf5sg56df4sh54fd64hh465dsfhd5f4hd64ha68fh6    tCodeBreakerScoresByName    table    insert    tCodeBreakerScores    CodeBreakerSetScores    getn        CodeBreakerWriteScoresToFile 	   sMessage    gsub    tScriptMessages    sQuizCorrectAnswer    !username! 	   !answer!    !time!    sQuizRankBehind    !nextrank! 
   sQuizRank    !score!    !totalscore!    !rank!    !totalrank! 	   !behind!    sCodeBreakerCode    TriggerCodeBreaker    TriggerCodeBreakerQPause    iQuestionsPause    Second     len    iQuestionLength    sub    tCode    sHiddenChar    sQuizCodeBreakerPartlyCorrect 
   !correct!    |                     .  2       E   F@� �   ��@�   �  d  �� �  A ]  ^    �       string    sub    gsub    (%S+)       �?       �       0  0       E   �   \� �@  U�� ^   �       CodeBreakerMixString                                       7  d    �   �@  �   ��  ��@�  �� �@ A A� �A �� � @����E FB�� �BBł ��� @� �� �B � \� G� � �  �E FB��� ��C�B � \� G� �  @A@�AB � �BBł Ƃ�C A� �� �� UG� B� ^  �E�  F�� �  \B�AB � �B `� �E F�I�_��A� � �F�B Ƃ�� ���� C �FAC �� �� � A � �F	�D Ƅ�	� ���� E �F
A� UB�G� AB � �BH��  ����B `B�  E F�FC�G� E F���� I� �AC GC	 @ �A�	 GC	 E� �C �C ƃ��	 @ �
 �D	 E
 @ ��
 Ņ � U�G� _�E� �B �B Ƃ� E F��C ��F�� \����
 U��G� �    @�W�A ��E F�Z  � �E F�F��^  � -      gsFunction    CodeBreakerSetScores    table    getn    tCodeBreakerScores                sScoresOutput    string    gsub    tScriptMessages    sQuizScoresTopX    !top!    !game!    CodeBreaker    sQuizScoresTop      ��@   

	    sQuizScoresNone    
    sort       �?      @   

		    rep    tGeneralSettings    sBorder       D@   
		    		 
   gsVersion         math    min 
   sUserName        @      $@   anscoretabs    	    	Rank.            Score.         		    

    tCodeBreakerScoresByName        H  H       � @ � � X��  ��@  � � �   �           @                                j  q           E@  F�� F�� @ �  E  F@� �� \� ��   ��� E� F��F���� �� 	���� �       dofile    tSettingPaths    sCodeBreakerScores       �?   table    getn    tCodeBreakerScores    tCodeBreakerScoresByName                     w  �     3      @@ E�  F�� F � �@ ����A � �@��  �  �@�� ܀  �@���A � @�� �B Ƃ�� E� FC�F�܂� E� FC�FC��� ��A�� ���A � E FA��� \� � ��@���A A �@���E �@  �       io    open    tSettingPaths    sCodeBreakerScores       �?   w    write    tCodeBreakerScores = {
    table    getn    tCodeBreakerScores    [    ] = {    string    format    %q    ,        @   },
    n=    
    };    close                     �  �    /   �@  �   ��  ��@  � �@��  �@Aŀ ��� F�@ �� �@ ƀ������  A E� F��F�� �A ���A Ɓ��@� �ŀ � � �� @ �� ��C�D� C ��C �BB��  �� �       gsFunction    CodeBreakerShowScores    CodeBreakerSetScores    sNick    string    gsub    tScriptMessages    sQuizShowScores    !username!    tCodeBreakerSettings    bPlayInMain       �?   SendMessage    all    tBots    tCodeBreaker    sName    sScoresOutput    pairs    tCodeBreakerPlayers                     �  �    9   A@  G   A�     @ �F�@ � ��  �@AF�A�@  ���   �  �� �� �@� �  �@C�  �@�� �CA �A ܀ � @� �� �� � �@� �ŀ � E FA�F��� �A �@�@��  A � ��� @ � �BA��A� C B��  @� �       gsFunction    CodeBreakerClearScores        sNick    tBots    tCodeBreaker    sName    tCodeBreakerScores    tCodeBreakerScoresByName    n            CodeBreakerWriteScoresToFile    string    gsub    tScriptMessages    sScoresCleared    !game!    CodeBreaker    !username!    tCodeBreakerSettings    bPlayInMain       �?   SendMessage    all    pairs    tCodeBreakerPlayers                     �  �    \   A@  G   E�  F��  �  �J   �@ ŀ � ��Ł  ������ �Ł �A�I����  ���  �@B�� �� � A�  �@�� ܀  C@ ��@ � �� �C@ �  A� � @ �@A �DE� � E� F�� ����W��@�E� �A�  ���I�E �A ��E�� � \A E � Ł ���B FAAB ��� ��܁  �A �� � \A E� � �A Ɓ���� BHA \A� � "      gsFunction    CodeBreakerArchiveScores    tCodeBreakerSettings    bArchiveScores       �?   ipairs    tCodeBreakerScores    iArchiveScores    os    date    %m    %y               (@   string    len    0    table    getn    tCodeBreakerScoresArchiveIndex 	   SaveFile    tSettingPaths    sCodeBreakerScoresArchiveIndex    gsub    sCodeBreakerScoresArchive    !filename!    tCodeBreakerScoresArchive    SendMessage    ops    tBots    tCodeBreaker    sName    tScriptMessages    sCodeBreakerScoresArchived                     �      �   �@  �   ŀ  ��� � A � ��A ���  �AF�A �  B �AB ��  ��B�� ��C ����� � CA� � �CD�� �  �BE� F��D ��A� �� �C	�� ���E� � \��� �� � CAD � �� ��a�  @�@ �� �� ��� E�  F���� �C�C \���� ������E��E F�Z  � �E ��@�E IBFE ���E�  F��� �G�B �A \� �� ��G��E F�Z   �E I�GE ��E�  F��� �BH�B �A \� ��@�E �����E�  F���� �� \��  �A@��    I��   � � �AI�� 	CF�  �FE F����	 ��A � � �  �FE�  F��� �J�C  �\� ��	 ��A � � ��@J@�   �� 	�G�  �FE F����	 ��A � � �  �FE�  F��� ��J�C  �\� ��	 ��A � � @ � �KAB Z    �AB �� � � LCL@ ���B��  ����� E @�W ���E� ���� ��	�D�	 �AE \D�!�  ��� E� FC�� � C  � 4      gsFunction    CodeBreakerMaintainPlayers    string    find    %$To:%s(%S+)        lower    sNick    S    

		    rep    tGeneralSettings    sBorder       9@   
		    		    tScriptMessages    sCodeBreakerPlayers    
    pairs    tCodeBreakerPlayers    	     

    J    sCodeBreakerJoinAlready       �?   sCodeBreakerJoinUser    gsub    sCodeBreakerJoinOp    !user!    L     sCodeBreakerLeaveUser    sCodeBreakerLeaveOp    sCodeBreakerJoinNot    %b<>%s+%S+%s+(%S+)    A    sCodeBreakerAddAlready    sCodeBreakerAddUser    !nick!    sCodeBreakerAddOp    D    sCodeBreakerRemoveUser    sCodeBreakerRemoveOp    sCodeBreakerAddNot            SendMessage    tBots    tCodeBreaker    sName 	   SaveFile    tSettingPaths                       5    w   �@  �   ��  ��   AA@� �� �� �A� � A� ��Z    ��  �  @��B � Ƃ�� CAC ܂�� E� F��� � � E F���� �C	�D \���� �� ��	 � �B � Ƃ�� E�@AC � � ��  �  @��� � Ƃ�� E�@AC � � �B  �� �  ��� �� ���� D E� F��� ��� FG�E ��@ � ���  @�� �B � CA� � ��B�� ��D ����C ��@�� ��Dł ��� [C   �A�  �� �  �B ƂH � ICI@ ���B� � &      gsFunction    CodeBreakerShowArchive           �?   string    find    %b<>%s+%S+%s+(%S+)    %$To:%s(%S+)            

		    rep    tGeneralSettings    sBorder       D@   
		    	 CodeBreaker Scores from     
 	   loadfile    gsub    tSettingPaths    sCodeBreakerScoresArchive    !filename!    dofile    tCodeBreakerScoresArchive    ipairs    		    	Rank.  
   		Score.         @   

    tScriptMessages    sCodeBreakerArchiveNot 
   !archive!    SendMessage    sNick    tBots    tCodeBreaker    sName                     ;  B           @@    �  E�  @   A@ �@  @� �       iCodeBreakerQuestion       �?   CodeBreakerQuestion    user    RemoveTimer    TriggerCodeBreakerQPause                     H  L           C � �@  @� �       CodeBreakerStopGame    TimeOut                     R  V           @@ ���  �@ @  � �  A@ �@ @� �       sGameInProgress     tMainBlock 	   bBlocked    CodeBreakerStartGame                         \  `           @�  �       CodeBreakerQuestionTime                     f  j           @�  �       CodeBreakerAutoStart                     p  t           @�  �       CodeBreakerQuestionPause                     z  ~           @�  �       CodeBreakerTimeOut                             