LuaQ    @dpi.EC           (À      A@  @    A  @    AÀ   E     \    Á@  Å    Ü   AÁ  E   \   ÁA  Å   Ü 
  AÂ  ÁB  AÃ  ÁÃ D D ÄDJ  bD D ÔE  D ÅEÆE  I
þ¤        ¤D       D  ÁÄ  J   ÊÅ  ÉÇÉÈÉÈ
Æ  	ÆÈ	É	FÉJ    ÊÊI  ËÊI ä    ÇF äÆ     Ç ä         $G           	   d     ¤Ç     
Ã d   ¤H    ä                                                $É   
       EÉ ¤	      I	dI                     ¤                        	¤É   		É ä	   ÉÉ äI     É	É ä ÉÉ äÉ         É	I ÉMÁ	  W@N     :      require 	   libtable    libos    devmarking 	   filesync    error 	   netrules    math.multiinterval    math.interval    math.tableset    net    dpi-settings.json .   com.netdumasoftware.devicemanager.dpisettings    /usr/bin/dpiclass #   /usr/lib/libdpipacketprocessors.so 	Q 	@8     os    platform_information    model =   http://netdumasoftware.com/dumaos/resources/dpi/%s/cloud.asc 	      string    format    save_settings    load_settings 	þ  	ÿ     com.netdumasoftware.autoadmin    pfield    pappid    cfield    appid    bits 		      pappcat    cappcat 	      forward    name    forward_dpi_mark    table    mangle    prerouting    prerouting_dpi_mark    on_get_appmark    on_get_catmark    rpc    flush_cloud    init    cleanup    get_cmark_mask    get_devmark    get_dpi_settings    set_dpi_settings    getenv    LUA_UNIT_TEST    dpi.lua                  E   F@À    Ä     ]  ^           os    save_settings                                      l              a    e                
À  	@@	À@	@AE FÀÁ    Ä     ]  ^           enabled    maximum_packet_scan 	      packet_buffer_size 	      os    load_settings                                                  l             a    e                  @@@   JA  A Ä  ÆÁÁÄ  ÆAÁÁÄ  ÆÁÁÄ  ÆÁÁÁÄ  ÆÂÁI@   	   	   g_handle    conn    reply    result    mask    lshift    max    pfield    cfield                                                                                      l           a              e                  @@@   JA  A Ä  ÆÁÁÄ  ÆAÁÁÄ  ÆÁÁÄ  ÆÁÁÁÄ  ÆÂÁI@   	   	   g_handle    conn    reply    result    mask    lshift    max    pfield    cfield                                                                                      e           l              a            r      Ê   
  E  FAÀKÀÁÁ   J  \@Á À  Ä  ËÁÁAÂ ÜÁÄ  ËÁÁAB ÜÁ   ÁBÀ  @Á À
ÆÃÚ  ÅA ÃÜÀC   CÃC ÃAÄ   À ÃA CDÆÄ    á  @úÅ ÆÄ A ÜAÄ  ËÁÁA ÜÁÅ ÆÄ  AÂ ÜAÊ 
Â  	J  IÆ  ÂAF I	B	ÂâA  G@  B   D@Â  Ê  ÉÆ  ÃAF ÉÂBB @        	   g_handle    conn    call    network.interface.lan    status    prerouting    ctstate    new    zonein    lan    table    clone    ipv4-address    ipairs    dstip    union    address    ip2long    insert    dstip6 
   fe80::/10    match    target    field    goto    value    name 	   negation    empty    unpack     r                                                                                                                                                                                                                                                                                                                                                               a     q      t     q      e    q      o    q      i    q      c 
   q      l    q      (for generator) %   <      (for state) %   <      (for control) %   <      a &   :      l &   :      e X   q         n    d    u             ¯   Ê  
  J    @  I @ I	AJ   ÁAI @I	AJ    Ä  ËÀA  ÜÁÄ ËÀAB ÜÁI  Ä ÆÁÁÁÄ ËÀDÜÁI  Ê   ÂAD KÀÄ\ÉA BD KÀÁÂ \ÉAÁÊ  ÉC @  ÉÁÊÁ  
  D FÂ @Ã 	D FÂÁ @	É
  	BCD KÀÄ ÆÃ\	BÉ
 A "B É
Â  J   BÄ ËÀAÃ ÜIÂ ÂAÄ ËÀDÜIÂ	BJ  IBC @  I	BJ  bB 	BJ  B  Ä ÆÂÁ @I  BDÄ ËÀA ÜÂIâ@     Á E@ Ê  
  D  KÀÁ  \	BD  KÀÁ \	BÉ
B  	ÂEÉA Þ          match    ctstate    new    proto 	      target    field    cfield    value 	      pfield 	       nfqueue    save    mask 	   negation    mark    dturbo 	      table    insert    zonein    lan    return     ¯                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       c     ®      i     ®      o     ®      e    ®         n    l    e    t    a     !   !    
,   Z       @    @  Å  Á  @   AÜ@ Ê  
  JÁ    AÄ ËÁAÂ ÜIÁ AB I A I	AJ  IÃ A   I	Aâ@ Þ          dport    sport    print    field    pfield    match    new 	       proto 	   	5      target    nfqueue    value     ,   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !   !         n     +      a     +      a    +         e    l     "   %    
$   Ú      AA    ÊÁ  ÉAÉ  ÂA@   ÉA   BE    À   AA BD  A W@Ã  ÂA  Â ÁA     
   long_call    com.netdumasoftware.autoadmin    add_custom_rule    name    tab    rules    json    encode    install    table    insert    hook 	   iscustom     $   "   "   #   #   #   #   #   #   #   #   #   #   #   #   #   $   $   $   $   $   $   $   %   %   %   %   %   %   %   %   %   %   %   %   %   %         l     #      e     #      a     #      n     #         c    i     (   +              À    @                    (   (   (   )   )   )   )   +             t     ,   /     	             B   @                 	   ,   ,   ,   -   -   -   -   -   /             n     0   ;    k   E   @  @ÁÀ  A FAA   \@  F A  A Æ@A   AD  FÁÁ AÄ ÆÁÁ BÂ Ä ÆBÂÆÂ ÃBBd                            C  C C  ÄÆCÃ D Ä  C
 Ü Ä DEÄ FDÄÄ  \     B D D  À  \ Á  DD  À \ Á  DD Â \Ä Á D D Â  \ Á D         print    string    format    starting dpi %s %s    maximum_packet_scan    packet_buffer_size    mask    lshift    get_devmark    forward    name    prerouting    !8Dn@%@^\Y8@}T2( 	   sync_tar    DPI    os    cyclic_timer    create_exp_backoff    mangle    input    output        :   :     ,      @@ A  @    @@ AÀ  @    @@ A  @    @@ AÀ  @ 
  	A@    Á  AÁ  Ä B D Ä Ã D Ä D D Ä "@	E   FÀÃ   À   \H         os    execute    killall dpiclass    sleep 1    killall -9 dpiclass    -q    -s    -r    -t    -u    -b    -m    -l    -d    -e    cycle_execute     ,   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :   :         e %   +         e    I    p    f    R    k    b    h    a    t    z k   0   0   0   0   0   0   0   0   0   1   2   3   3   4   4   5   5   6   6   7   7   7   7   8   8   8   9   9   9   :   :   :   :   :   :   :   :   :   :   :   :   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;         l     j      f 	   j      p 
   j      R    j      i    j      I    j      k    j      b    j      h    j      a    j      e    j      s    j      c    j      l )   j      a 0   j      l :   j         e    a    h    m    r    t    z    _    u    y    o    q    n    v    x    d    g    w     <   B     )         @      Á@  `D  FÀ  Á  Á B JÂ  ÂÁIÂI ÂBÆBÂ IA  CÅÁ  BÂFÂÁÂA_ÀøJ   H   D  \@ D \@      	   	ÿÿÿÿ	   iscustom 
   long_call    com.netdumasoftware.autoadmin    del_custom_rule    name    hook    tab    rules    json    encode 
   uninstall     )   <   <   =   =   =   =   >   >   >   >   >   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   @   @   @   @   @   @   @   =   B   B   B   B   B   B   B         e    (      (for index)    "      (for limit)    "      (for step)    "      e    !      e    !         i    c    _    u     C   C           @   E   \  @          load_settings        C   C   C   C   C   C   C             t    f     D   R     k      @    A@    ÊÀ  É ÁÉÁ ABJ  bA  É @  D   @FÁBZ  @J  À  bA   CÅ   @ A	AÃFCZ  @	ACE  A  ÁÁ   \A !  Àø       A@    Ê@   É @   ÀD    À   E    À   A@  @ Ê@   ÁEÉ @    A@  @ Ê@   FÉ @  ÀD    À  E    À   A@  @ Ê@  ÁEÉ @    A@  @ Ê@  FÉ @      
   long_call    com.netdumasoftware.autoadmin 	   del_rule    hook    forward    tab    mangle    rules    json    encode    pairs    goto_installed 
   uninstall  
   installed    destroy_chain    release_nfqueue    id    nfq    mask    lshift 
   unreserve 	   subfield    pfield    cfield     k   D   D   D   D   D   D   D   D   D   D   D   D   D   D   D   D   D   D   D   D   E   E   E   F   F   F   F   F   F   F   F   F   F   F   F   F   F   H   H   H   I   J   J   J   J   J   D   J   L   L   L   M   M   M   M   M   M   M   N   N   N   N   N   N   N   N   O   O   O   O   O   O   O   O   O   O   O   O   O   O   O   O   P   P   P   P   P   P   P   P   Q   Q   Q   Q   Q   Q   Q   Q   Q   Q   Q   Q   Q   Q   Q   Q   R         (for generator)    0      (for state)    0      (for control)    0      l    .      e    .      a    %         t    s    r    k    c    m    e    a     S   X   
        J  ¤                   Å@  
 dA   "A Ü  b@  @         try    catch        S   X   	  Y      A@    Ä    EÀ  F Á    À   \@E   @  Á   \    EÀ  F Á   À   \@E   @  Á@ 
  \ H  E  \ À  ÁA   @ I  Ä  @ Ü¢A  ÄÆAÂ  @  Á ÜAIÃa  @úJ     I   ÄÄ ËÄD FÁÄÜÀI H  E   @  Á  
Á  	Å	ÂEA FÆ Ä ¢A \ 	A\@ EÀ \  Ç       À  @      
   long_call    com.netdumasoftware.autoadmin    dualreserve    table    merge    acquire_nfqueue    pairs 
   installed    create_chain    install    mangle    goto_installed    match    target    field    restore    value    new    mask 	   add_rule    hook    forward    tab    rules    json    encode    load_settings    enabled     Y   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   T   S   T   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   V   W   W   W   X         n    X      (for generator)    5      (for state)    5      (for control)    5      l    3      e    3      a +   3      e R   X   	      e    a    m    r    k    c    s    l    f     X   X       D   \@ E      \@         error        X   X   X   X   X   X         e              o    S   S   X   X   X   X   X   X   X   X   X   X   X   X   X   X   X   X   X   S   X       
      e    a    m    r    k    c    s    l    f    o     Y   Y           @              Y   Y   Y             o     Z   [            @ D   F@À          lshift    mask        Z   Z   Z   Z   Z   [             e     \   \            @              get_devmark        \   \   \   \   \             h     ]   ]                         load_settings        ]   ]   ]   ]               ^   j    	0   Å     Ü @ Å     Ü  Á@    EÁ  \    @XÀ @  @ Ä  ÆAÁ Ü A  XÀÁ @ @ @ Ä  ÆAÁB Ü A  IA II  A      ÀA A ÀA      	   tonumber 	   	  P    load_settings    error    ERROR_VALIDATION    Invalid buffer size. 	   	      Invalid packet scan size.    maximum_packet_scan    packet_buffer_size    enabled    save_settings     0   ^   ^   ^   ^   ^   ^   ^   ^   ^   _   `   `   `   `   a   a   a   a   b   b   b   b   b   b   c   c   c   c   d   d   d   d   d   d   e   f   h   i   i   i   i   i   i   i   j   j   j   j         n     /      a     /      l     /      o 	   /      i 
   /      e    /         b    t    f À                                                                                                                                                                                                   	   
                                                                                                                        !   !   !   %   %   %   &   +   +   /   /   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   ;   B   B   B   B   B   C   C   C   C   C   R   R   R   R   R   R   R   R   R   X   X   X   X   X   X   X   X   X   X   X   S   Y   Y   Y   Z   [   [   Z   \   \   \   \   ]   ]   ]   ^   j   j   j   j   ^   k   k   k   k   k   k   l   m   *      h 	   ¿      y    ¿      b    ¿      c    ¿      d    ¿      l    ¿      n    ¿      u    ¿      p    ¿      a     ¿      e !   ¿      z "   ¿      q #   ¿      v $   ¿      x %   ¿      t &   ¿      t *   ¿      o -   ¿      (for index) 0   8      (for limit) 0   8      (for step) 0   8      e 1   7      t A   ¿      e B   ¿      e C   ¿      i D   ¿      m E   ¿      e I   ¿      a M   ¿      r V   ¿      s W   ¿      k a   ¿      g g   ¿      w j   ¿      d m   ¿      t n   ¿      n n   ¿      u p   ¿      _ r   ¿      f    ¿      t    ¿      o    ¿       