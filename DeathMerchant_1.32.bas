  rem ________________________________________________________________________________
  rem
  rem                       Death Merchant for the Atari 7800
  rem                                 Version 1.30
  rem                            Created with 7800Basic  
  rem                            Copyright (C)2017-2022
  rem                        Programmed by Steve Engelhardt
  rem                             Started: 08/05/2017
  rem                            Completed: 07/09/2022
  rem
  rem                              Download 7800Basic:                               
  rem                  http://7800.8bitdev.org/index.php/7800basic
  rem
  rem ________________________________________________________________________________
 
  rem ________________________________________________________________________________
  rem
  rem   Initial item values
  rem 
  rem       These are the initial values for all of your stats.  
  rem       They may be changed after some additional play testing.
  rem  
  rem       Credits    5000/999999
  rem       Bank          0/999999
  rem       Debt      35000/999999
  rem 
  rem       Food      50/99
  rem       Backpack  50/50
  rem       Stamina   99/99
  rem       Health    50/99
  rem       Dexterity 10/99
  rem       Charisma  10/99
  rem       Knives    25/99
  rem   
  rem                                                   
  rem     Dexterity        
  rem     ---------------  Increases chances of winning fight
  rem                      Initial value is 10.
  rem                      Dex increases by 1 by beating entire Criminal Gang
  rem                      Dex increases by 5 with each training session
  rem                           Enemy Hit chance is set in the "AttackRandomization" Subroutine
  rem                           Dex Level 1 (30-60), Enemy Hit Chance is 50%
  rem                           Dex Level 2 (60-90), Enemy Hit Chance is 60%
  rem                           Dex Level 3 (90-95), Enemy Hit Chance is 75%
  rem                           Dex Level 4 (96-99), Enemy Hit Chance is 100%
  rem 
  rem     Charisma         
  rem     ---------------  Reduces interest on debt. 
  rem                      Over 40, reduced to $500 a day, over 80, reduced to $300 a day. 
  rem                      Changes can be made in the "CharismaModifier" subroutine
  rem 
  rem     Stamina          
  rem     ---------------  Stamina affects both your ability to fight, and your health when it reaches zero.
  rem                      You cannot fight if it's zero
  rem                      You lose 2 stamina for every day that you travel.
  rem                      If it reaches zero, you receive an additional daily health penalty of -2, for a total of -4 per day.
  rem                      Rest is the only way to increase Stamina, noted in the "Finished Resting" subroutine.
  rem                           if Stamina>$49 then Stamina=$99
  rem                           if Stamina<$50 then dec Stamina=Stamina+$40
  rem
  rem     Fighting         
  rem     ---------------  Fighting is random or manually chosen.  You are sometimes attacked when travelling.
  rem                      You can manually start a fight when in any city.
  rem                      Currently you can always run away from a fight, no real difference between getting attacked or manually starting a fight.
  rem                      Your stamina and knives must both be over zero in order to enter a fight.
  rem
  rem                      Positives                             Negatives
  rem                      ----------                            ----------
  rem                      1 Dexterity Bonus                     Possible Death 
  rem                      Random Cash Bonus ($0-$10,000)        Loss of Knives (Dropped or broken)
  rem                          (if entire group killed)          Loss of Stamina and Health
  rem                      5 Knives
  rem
  rem     Knives
  rem     ---------------  Knives are only needed/used whenever you fight.
  rem                      You may break or drop a knife when fighting.
  rem                      You must have at least one knife in order to enter a fight.
  rem                      Knives can be found when travelling or purchased from the Merchant for $100 each.
  rem                      You can carry a maximum of 99 knives at any given time.
  rem
  rem     Travelling
  rem     ---------------  Travelling will result in many different random events occurring, listed below.
  rem                          Main Random Events (0-7).  
  rem                          If 0 or 1 come up, that triggers sub events for pricing changes or getting attacked.
  rem                          These are triggered in the "TravelEventsLoop" subroutine.
  rem                               0 - Pricing Event
  rem                                      0a  Matches price drop
  rem                                      0b  Rope price drop
  rem                               	     0c  Canteen price increase
  rem                                      0d  Tobacco price increase
  rem                                      0e  Matches price increase
  rem                                      0f  Canteen price drop
  rem                                      0g  Clothes price drop
  rem                                1 - Attacked
  rem                                      1a  Escape
  rem                                      1b  Fight, lose 5 Food
  rem                                      1c  Escape
  rem                                      1d  Fight
  rem                                      1e  Escape, lose 6 Stamina
  rem                                      1f  Escape, lose 4 Stamina
  rem                                      1g  Fight
  rem                                 2 - You find $2200 on a corpse 
  rem                                 3 - You earn $1000 bank deposit (loyalty program)
  rem                                 4 - Merchant Appears
  rem                                 5 - You find 8 knives
  rem                                 6 - Nothing happens or you may be robbed 
  rem                                 7 - You find 10 food
  rem 
  rem     Health (HP) 
  rem     ---------------  Health must remain over zero to continue the game, if it reaches zero the game is over.         
  rem                      You can increase your health to a full 99 by visiting the Doctor in New Vegas for a random fee.
  rem                      It is decreased when you fight and take damage (-1 with each hit from a criminal)
  rem                            Can be found in various locations in the "screenAttacked" subroutine.
  rem                            dec Health=Health-1
  rem                      It is decreased daily by -2 if you have zero Stamina (in the "FinishTheDay" subroutine.)
  rem                            if Stamina=$00 && Health>$01 then dec Health=Health-2
  rem                      Death if it reaches zero (at any time)
  rem 
  rem     Food           
  rem     ---------------  Food is necessary to maintain your Stamina. It has a maximum value of 99.
  rem                      It can be acquired from either Resting in Bedford or purchasing it from the Merchant, who appears randomly. 
  rem                      If it falls to zero, you have an additional daily stamina drop of -1, in addition to the normal drop of -2. 
  rem                      Rest in the safe house to acquire additional food. The lines of code below are in the "FinishedResting" subroutine.
  rem                            if scoreFoodLo>$59 then scoreFoodLo=$99
  rem                            if scoreFoodLo<$60 then dec scoreFoodLo=scoreFoodLo+$35
  rem                      Buy food rations for $100 each from the Merchant.
  rem                      Automatically decreases by -3 when you travel.  It can be changed in the "FinishTheDay" subroutine.
  rem                            if scoreFoodLo>$03 then dec scoreFoodLo=scoreFoodLo-$03  (Normal Daily Decrease)
  rem                            if scoreFoodLo=$00 && Stamina>$00 then dec Stamina=Stamina-1 (Additional drop when Stamina is zero)
  rem
  rem     Lender           
  rem     ---------------  You Start with $40,000 in debt
  rem                      Interest is charged daily, but is modified by your Charisma and the number of days remaining in the game.
  rem                      Once Debt is paid down to zero, no interest is accrued and you are done with the lender for the remainder of the game.
  rem                      Interest Payments:
  rem                           Specified in the "FinishTheDay" subroutine.
  rem                            Add $700 per day on Days 1-7, Add $900 per day on Days 8-31
  rem                           Once your Charisma reaches 40 or more, interest calculations are overridden and modified.
  rem                            Add $500 a day if Chasrisma is over 40
  rem                            Add $300 a day if Charisma is over 80
  rem
  rem     Merchant 
  rem     ---------------  The Merchant randomly appears throughout the game, generally around 0-3 times, but it's random.
  rem                      The items offered are the same every time, and the prices are static and never change.
  rem                      The merchant is the only way to get a bigger backpack, Knives - food can be had resting.  
  rem                      You gain Charisma with every purchase you make from the merchant, which gives you free stuff and
  rem                        also reduces your interest on debt.  See the Charisma section for more detail.
  rem                      You can only acquire the backpack from the Merchant.  It increases your usable space from 50 to 99,
  rem                        and it can only be purchased once.  You can never have more than 99 units of total space. 
  rem                      Merchant Items and prices.  Details are in the "screenMerchant" subroutine.
  rem                             Canteen        $100
  rem                             Knives         $500
  rem                             Rope           $500
  rem                             Food           $100
  rem                             Big Backpack   $9500
  rem
  rem     Bank             
  rem     ---------------  Money can be deposited to prevent it being taken from you in a robbery when travelling.
  rem                      Any deposits into the bank will result in a $500 per day interest payment.
  rem                      If you have more than $10,000 in the bank, you will get $1500 a day in interest.
  rem                      You cannot spend money that's in the bank, it must be withdrawn first.
  rem                      You may only visit the bank when in the city of Lost Angeles.
  rem                      There is no fee for Bank transactions.
  rem                      More detail in the "screenBank" subroutine.
  rem
  rem     Rest 
  rem     ---------------  Resting is free, but it costs you one day of game time.
  rem                      You can only rest while in the city of Bedford.
  rem                      It increases both your Stamina and your Food.
  rem                      The Stat increases for a rest day are in the "FinishedResting" subroutine.
  rem                            if Stamina>49 then Stamina=99
  rem                            if Stamina<50 then dec Stamina=Stamina+40
  rem                            if scoreFoodLo>$59 then scoreFoodLo=$99
  rem                            if scoreFoodLo<$60 then dec scoreFoodLo=scoreFoodLo+$35
  rem
  rem     Training
  rem     ---------------  You can only train in the city of New Salem.
  rem                      Training costs a random amount of credits.
  rem                      Training offers a +5 Dexterity Bonus.
  rem                      You can train as many times as you want, up to your Dexterity limit.
  rem                      See the Dexterity section for more info on how it affects the game, but it increases your chance to win a fight.
  rem                      more detail in the "screenTrain" subroutine.
  rem
  rem     Stats
  rem     ---------------  The stats screen is informational and does not affect the outcome of the game.
  rem                      You can freely go back and forth from this screen with no penalty, and it can be accessed when in any city.
  rem                      More detail in the "screenStats" subroutine.
  rem                      Stats are tracked for:
  rem                              the number of times you've trained
  rem                              Dexterity Bonus
  rem                              Charisma Bonus
  rem                              Gangs killed
  rem                              Days Rested
  rem                              Bank Transactions completed.
  rem                      The stats screen is also the "Game Over" screen when you die or run out of days.
  rem 
  rem     Doctor
  rem     ---------------  The doctor can only be visited in the city of New Vegas.
  rem                      The doctor charges a random fee, and will restore your health to the full amount (99).
  rem                      The doctor is only available if your health is below 99 and you have enough credits to pay.
  rem                      More detail in the "screenDoctor" subroutine.
  rem
  rem     Buy/Sell
  rem     ---------------  This one is fairly obvious. :)
  rem                      You can select items to buy or sell only one at a time.  After an item has been bought or sold, you are taken back to the main screen.
  rem                      You will not be allowed to select more of an item than you can afford, or more of an item than you own to sell it.
  rem                      The Buy and Sell screens can of course be accessed from any city in the game.

 displaymode 320A

 rem ** Set all of the kernel options for 7800basic
 set tv ntsc
 rem set avoxvoice on
 set basepath dm_gfx
 set screenheight 224
 rem this uses up $2700 to $27ff, adds 256 digits to use with plotvalue
 set plotvaluepage $27
 set romsize 48k
 set zoneheight 8

 rem ******************************************
 rem **************** Graphics ****************
 rem ******************************************

 rem ** map graphic
 incbanner dm_map2.png 320A 1 0 2 
 
 rem * title screen graphic
 incgraphic aa_left_1b.png 320A 0 1 2 
 incgraphic aa_left_2b.png 320A 0 1 2 
 incgraphic aa_left_3b.png 320A 0 1 2 
 incgraphic aa_left_4b.png 320A 0 1 2 
 incgraphic aa_right_1.png 320A 0 1 2 
 incgraphic aa_right_2.png 320A 0 1 2 
 incgraphic aa_right_3.png 320A 0 1 2 
 incgraphic aa_right_4.png 320A 0 1 2 

 rem ** import the characterset png
 incgraphic dm_atascii4.png 320A 

 rem ** Import background menu selection graphic
 incgraphic dm_menuicon.png 320A 

 rem ** Import the graphic digits for the score
 incgraphic dm_scoredigits.png 320A 0 1 2 

 rem ** Import Sprite Graphics
 incbanner dm_merchant.png 320A 0 1 2 
 incbanner dm_hero2.png 320A 0 1 2 
 incbanner dm_criminal4.png 320A 0 1 1

 rem ** import item icon sprites
 incgraphic dm_icon_matches.png 320a 0 1 2
 incgraphic dm_icon_firstaid.png 320a 0 1 2
 incgraphic dm_icon_shovel.png 320a 0 1 2
 incgraphic dm_icon_rope.png 320a 0 1 2
 incgraphic dm_icon_compass.png 320a 0 1 2 
 incgraphic dm_icon_GPS.png 320a 0 1 2 
 incgraphic dm_icon_flare.png 320a 0 1 2 
 incgraphic dm_icon_fuse.png 320a 0 1 2 
 incgraphic dm_icon_clothes.png 320a 0 1 2 
 incgraphic dm_icon_canteen.png 320a 0 1 2 
 incgraphic dm_icon_tobacco.png 320a 0 1 2 

 incbanner dm_logo1a.png 320a 0 1 2
 incbanner dm_logo2a.png 320a 0 1 2
 incbanner dm_logo3a.png 320a 0 1 2
 incbanner dm_logo4a.png 320a 0 1 2
 incbanner dm_logo5a.png 320a 0 1 2
 incbanner dm_logo6a.png 320a 0 1 2
 incbanner dm_logo7a.png 320a 0 1 2
 incbanner dm_logo8a.png 320a 0 1 2
 incbanner dm_logo9a.png 320a 0 1 2
 incbanner dm_logo10a.png 320a 0 1 2
 incbanner dm_logo11a.png 320a 0 1 2
 incbanner dm_logo12a.png 320a 0 1 2
 incbanner dm_logo13a.png 320a 0 1 2

 incgraphic myname2.png 320a 0 1 2

 rem ** set the current character set
 characterset dm_atascii4

 rem incbanner title.png 320A 1 0 2

 rem ** set the letters that represent each graphic character...
 alphachars ASCII

 rem ** Set up Variables
 rem ** Available RAM we can assign and use:
 rem ** ...The range of letters A -> Z
 rem ** ...The range of 'var0' -> 'var99'
 rem ** ...RAM locations $2200 -> $26FF

 rem ** Menu and Joystick related
 dim menubarx=a       :rem  X location of the menu selection sprite 
 dim menubary=b       :rem  X location of the menu selection sprite 
 dim menuPos=c        :rem  Tracks the location of the menu selection sprite 
 dim debounce=d       :rem  Tracks the joystick button press 
 dim menuColor=e      :rem  Allows for menu color changes

 rem ** Flags for Menu Selections and Events in the game 
 dim flagItem=f       :rem  Flag for finding random items
 dim flagAttacked=g   :rem  Flag for Fight/Attack option 
 dim flagEvent=h      :rem  Flag for Event occuring
 dim flagLender=i     :rem  Flag for selecting the Lender option on the main menu
 dim flagFight=j      :rem  Flag for selecting 'Fight' on the main menu
 dim flagBuy=k        :rem  Flag for selecting the Buy option on the main menu
 dim flagSell=l       :rem  Flag for selecting the Sell option on the main menu
 dim flagTravel=m     :rem  Flag for selecting the Travel option on the main menu
 dim flagDoctor=n     :rem  Flag for selecting the Doctor option on the main menu
 dim flagBank=o       :rem  Flag for selecting the Deposit option on the main menu 
 dim flagTrain=p      :rem  Flag for selecting the Train option on the main menu
 dim flagRest=q       :rem  Flag for selecting the rest option on the main menu

 rem ** Misc Variables
 dim RandEnemies=r    :rem  Random Enemy generator when attacked
 dim RandomEvent=s    :rem  Random generator for random pricing event
 dim RandMoney=t      :rem  Random generator for random money found
 dim RandCashMed=u    :rem  Used to hold random amount of money found travelling  
 dim RandCashLo=v     :rem  Used to hold random amount of money found travelling
 dim RandEvent=w      :rem  For determining random events when travelling 
 dim daysleft=x       :rem  Tracks the days remaining in the game
 dim City=y           :rem  Track active city
 dim RandomSeed=z     :rem  Randomizer

 rem ** Item Prices
 rem ** -----------
 rem ** Variables that hold the price values for all items.
 rem **   Prices are two bytes in size (16bit - 0000)
 rem ** Example:
 rem **   If Rope is valued at $4,450
 rem ** priceRopeMed   priceRopeLo
 rem **   44             50t
 dim priceMatchesMed=var1   :rem thousands, hundreds  (Of $1234, it's 12)
 dim priceMatchesLo=var2    :rem tens, ones (Of $1234, it's 34)
 dim priceFirstAidMed=var3  
 dim priceFirstAidLo=var4  
 dim priceShovelMed=var5
 dim priceShovelLo=var6
 dim priceRopeMed=var7
 dim priceRopeLo=var8
 dim priceCompassMed=var9
 dim priceCompassLo=var10
 dim priceGPSMed=var11
 dim priceGPSLo=var12
 dim priceFlareMed=var13
 dim priceFlareLo=var14
 dim priceFuseMed=var15
 dim priceFuseLo=var16
 dim priceClothesMed=var17
 dim priceClothesLo=var18
 dim priceCanteenMed=var19
 dim priceCanteenLo=var20
 dim priceTobaccoMed=var21
 dim priceTobaccoLo=var22

 rem ** Item Quantity 
 rem ** -------------
 rem ** Variables that store the quantity of each item that you have purchased
 rem **   Quantity owned is one byte ($00)
 rem ** You can never own more than 99 of a single item
 dim ownMatches=var23           :rem Stores the number of Matches owned
 dim ownFirstAid=var24          :rem Stores the number of First Aid kits owned
 dim ownShovel=var25            :rem Stores the number of Shovels owned
 dim ownRope=var26              :rem Stores the number of Rope bundles owned
 dim ownCompass=var27           :rem Stores the number of Compasses owned
 dim ownGPS=var28               :rem Stores the number of GPS's owned
 dim ownFlare=var29             :rem Stores the number of Flares owned
 dim ownFuse=var30              :rem Stores the number of Fuses owned
 dim ownClothes=var31           :rem Stores the number of Clothes owned
 dim ownCanteen=var32           :rem Stores the number of Canteens owned
 dim ownTobacco=var33           :rem Stores the number of Tobacco packs owned

 rem ** Misc Variables
 rem ** --------------
 dim JoyMoveUpDebounce=var34    :rem Variable for keeping track of joystick movement
 dim JoyMoveDownDebounce=var35  :rem Variable for keeping track of joystick movement
 dim JoyMoveLeftDebounce=var36  :rem Variable for keeping track of joystick movement
 dim JoyMoveRightDebounce=var37 :rem Variable for keeping track of joystick movement
 dim ownKnives=var38            :rem Variable for storing how many knives you own 
 dim Health=var39               :rem Variable for storing your Health Stat 
 dim Dexterity=var40            :rem Variable for storing your Dexterity Stat 
 dim Charisma=var41             :rem Variable for storing your Charisma Stat 
 dim flagStats=var42            :rem Variable for tracking when you jump to the Stats Screen
 dim GameOver=var43             :rem Game Over flag set when days remaining drops to 0
 dim Death=var44                :rem Flag for when your character dies (with days still remaining) 
 dim RandCashHi=var45           :rem Random cash value generator
 dim Stamina=var46              :rem Stamina value.  Needed to fight.
 dim FightingFlag=var47         :rem Flag for use on fighting screen
 dim DisplayFlag=var48          :rem Flag for info to display on fighting screen 
 dim DexLevel=var49             :rem Dexterity Skill Level (1-5)
 dim CharismaFlag=var50         :rem Flag for receiving Merchant Charisma Bonus 
 dim BackpackFlag=var51         :rem Flag for having purchased the bigger backpack
 dim ExtraEnemyFlag=var52       :rem Flag for adding additional enemies into the fight

 rem ** Stat Variables
 rem ** --------------
 dim statCountTraining=var53    :rem for the Stats screen.  Counts number of times you've been trained.
 dim statDexterityBonus=var54   :rem for the Stats screen.  Keeps track of your Dexterity bonus total.
 dim statCharismaBonus=var55    :rem for the Stats screen.  Keeps track of your Charisma bonus total.
 dim statCriminalsKilled=var56  :rem for the Stats screen.  Keeps track of the number of criminals you've killed.
 dim statDaysRested=var57       :rem for the Stats screen.  Keeps track of the number of days you rested.
 dim statBankTransactions=var58 :rem for the Stats screen.  Keeps track of the number of bank transactions.

 rem ** Misc
 rem ** ---------------
 dim DebtCompare=var59      :dim CreditCompare=var60 :dim ZeroCompare=var61
 dim FlagTripEnd=var62      :dim BankCompare=var63   :dim heroMove=var64
 dim menuColor1=var65       :dim menuColor2=var66    :dim menuColor3=var67
 dim menuColor4=var68       :dim menuColor5=var69    :dim menuColor6=var70
 dim menuColor7=var71       :dim lineColor=var72     :dim bloodDrop=var73
 dim bloodDrop2=var74       :dim escapeFlag=var75    :dim escapeRand=var76

 dim logoY1=var78 
 dim logoY2=var79
 dim logoY3=var81 
 dim logoY4=var82 
 dim logoY5=var95 
 dim logoY6=var96 
 dim logoY7=var98 
 dim logoY8=var99 

 dim heroC=$26FB
 dim trainingFlag=$26FC

 ;dim logoY11=$26FD
 ;dim logoY12=$26FE
 ;dim logoY13=$26A1

 rem ** Item Selection
 rem ** --------------
 rem ** Variables that store the quantity of items you're interested in purchasing
 rem ** They are used only on the buy and sell screens
 rem **   Quantity you can select is one byte ($00)
 rem ** You can never buy or sell more than 99 of a single item
 dim selectMatches=var83    :dim selectFirstAid=var84    :dim selectShovel=var85
 dim selectRope=var86       :dim selectCompass=var87     :dim selectGPS=var88
 dim selectFlare=var89      :dim selectFuse=var90        :dim selectClothes=var91
 dim selectCanteen=var92    :dim selectTobacco=var93     :dim selectDone=var94

 rem ** Buy Items
 rem ** ---------
 rem ** the buy* variables keep track of the quantity you are about to buy
 rem ** It is a selection on the buy screen
 dim buyMatches=$26A6       :dim buyFirstAid=$26A7   :dim buyShovel=$26A8
 dim buyRope=$26A9          :dim buyCompass=$26AA    :dim buyGPS=$26AB
 dim buyFlare=$26AC         :dim buyFuse=$26AD       :dim buyClothes=$26AE
 dim buyCanteen=$26AF       :dim buyTobacco=$26B0    :dim buyKnives=$26BC
 dim buyFood=$26BD

 rem ** Sell Items
 rem ** ----------
 rem ** the sell* variables keep track of the quantity you are about to sell
 rem ** It is a selection on the sell screen
 dim sellMatches=$26B1      :dim sellFirstAid=$26B2  :dim sellShovel=$26B3
 dim sellRope=$26B4         :dim sellCompass=$26B5   :dim sellGPS=$26B6
 dim sellFlare=$26B7        :dim sellFuse=$26B8      :dim sellClothes=$26B9
 dim sellCanteen=$26BA      :dim sellTobacco=$26BB   :dim sellKnives=$26BE
 dim sellFood=$26BF

 rem Variables added in July 2022, some may not be used, some were to test
 dim backpackFree=$26E1
 dim fadeindex=$26E2
 dim fadeluma=$26E3
 dim scoreRewardLo=$26E4
 dim scoreRewardMed=$26E5
 dim bonusKnives=$26E6
 dim bonusRand=$26E7
 dim menuColor8=$26E8
 dim soundcounter=$26E9
 dim rankFlag=$26EA
 dim tempSpaceCheck=$26EB
 dim buyFlag=$26ED
 dim rolloverCheck=$26EE
 dim rolloverFlag=$26FF
 dim checkCredits=$26F1
 dim rolloverFlag2=$26F2
 dim bankClosedFlag=$26F5
 dim xLine=$26F6
 dim flagTravelLine=$26F7
 dim xLine2=$26F8
 dim heroX=$26F9
 dim logoY=$26FA

 rem ** Score Variables (score0-9,scoreA-scoreZ)
 rem **
 rem ** All score variables are three bytes (24 bit)
 rem **  -Therefore the next two variables after the assigned variable are automatically assigned
 rem ** Example:
 rem **  if score0 equals 123456
 rem **  scoreFoodHi  scoreFoodMed  scoreFoodLo
 rem **  12           34            56
 rem ** Note that indivudal bytes are dim'd for mathematical fuctions to be run 
 rem **
 rem ** scoreC (Used Backpack Space)
  dim scorec=var97
   dim scoreUsedBackpackSpaceHi=scorec :dim scoreUsedBackpackSpaceMed=scorec+1 :dim scoreUsedBackpackSpaceLo=scorec+2 
 rem ** score6 (Total Backpack Space)
  dim score6=$2699 
   dim scoreTotalBackpackSpaceHi=score6:dim scoreTotalBackpackSpaceMed=score6+1:dim scoreTotalBackpackSpaceLo=score6+1
 rem ** score0 (Food)
   dim scoreFoodHi=score0        :dim scoreFoodMed=score0+1        :dim scoreFoodLo=score0+2
 rem ** score1 (Available Credits)
   dim scoreCreditsHi=score1     :dim scoreCreditsMed=score1+1     :dim scoreCreditsLo=score1+2
 rem ** score4 (Bank Credits)
  dim score4=$26F3
   dim scoreBankHi=score4        :dim scoreBankMed=score4+1        :dim scoreBankLo=score4+2
 rem ** score5 (Debt Credits)
  dim score5=$2696
   dim scoreDebtHi=score5        :dim scoreDebtMed=score5+1        :dim scoreDebtLo=score5+2
 rem ** score7 (Temp Variable)
  dim score7=$269C
   dim scoreVarHi=score7         :dim scoreVarMed=score7+1         :dim scoreVarLo=score7+2
 rem ** scoreX
  dim scorex=$26CB             
   dim tempscorexHi=$26CB        :dim tempscorexMed=$26CC          :dim tempscorexLo=$26CD    
 rem ** scoreY
  dim scorey=$26CE            
   dim tempscoreyHi=$26CE        :dim tempscoreyMed=$26CF          :dim tempscoreyLo=$26D0   
 rem ** scoreZ 
  dim scorez=$26D1              
   dim tempscorezHi=$26D1        :dim tempscorezMed=$26D2          :dim tempscorezLo=$26D3    
 rem ** scoreA
  dim scorea=$26D4             
   dim tempscoreaHi=scorea       :dim tempscoreaMed=scorea+1       :dim tempscoreaLo=scorea+2 
 rem ** scoreB 
  dim scoreb=$26D8 
   dim tempscorebHi=scoreb       :dim tempscorebMed=scoreb+1       :dim tempscorebLo=scoreb+2 
 rem ** scoreD  
  dim scored=$26D9
   dim creditvaluecheckHi=scored :dim creditvaluecheckMed=scored+1 :dim creditvaluecheckLo=scored+2
 rem ** scoreE 
  dim scoree=$26DA
   dim debtvaluecheckHi=scoree   :dim debtvaluecheckMed=scoree+1   :dim debtvaluecheckLo=scoree+2
 rem ** scoreF
 dim scoref=$26F4
   dim bankvaluecheckHi=scoref   :dim bankvaluecheckMed=scoref+1   :dim bankvaluecheckLo=scoref+2
 rem ** Random Costs
 rem ** score8 
  dim score8=var77
   dim scoreTotalCostHi=score8   :dim scoreTotalCostMed=score8+1   :dim scoreTotalCostLo=score8+2
 rem ** score9 
  dim score9=var80
   dim scoreRobbedHi=score9      :dim scoreRobbedMed=score9+1      :dim scoreRobbedLo=score9+2
 rem ** Values below are used in math subroutines
  dim tempQty=$26C7
  dim tempPriceHi=$26C8          :dim tempPriceMed=$26C9           :dim tempPriceLo=$26CA  

 rem ***********************************************
 rem **************** Set Variables ****************
 rem ***********************************************

 rem **set color of 320A text palettes

 rem In 320C mode, even pixel pairs use the first two colors in the palette, 
 rem and odd pixel pairs use the last two colors in the palette.

 rem 320B mode requires pairs of pixels to use the same palette. 
 rem 320D requires pixels in odd columns to use the first two palette colors, 
 rem and pixels in even columns to use the last two palette colors.

  rem ** Set intial value of temporary price variables to 0 (used in math calculations)
 rem ** Removed in test v57, don't think it's necessary
 ;tempPriceLo=$00:tempPriceMed=$00

 rem ** Jump to Title Screen
 goto titlescreen

  rem *******************************************
  rem **************** Main Loop ****************
  rem *******************************************
start
 rem **set color of 320A text palettes
 P0C2=$08: rem Grey         
 P1C2=$06: rem Dark Grey
 P2C2=$1E: rem Light Yellow 
 P3C2=$CA: rem Green 
 P4C2=$88: rem Blue         
 P5C2=$28: rem Orange
 P6C2=$48: rem Light Red    
 P7C2=$1A: rem Dark Yellow

 if RandomSeed>0 then rand=RandomSeed
 priceRopeMed=$50
 priceGPSMed=$20
 xLine=14
 flagTravelLine=0

 rem ** Score Variables
 scoreFoodHi=$00:     scoreFoodMed=$00:     scoreFoodLo=$50
 scoreCreditsHi=$00:  scoreCreditsMed=$75:  scoreCreditsLo=$00 
 scoreBankHi=$00:     scoreBankMed=$00:     scoreBankLo=$00
 scoreDebtHi=$03:     scoreDebtMed=$50:     scoreDebtLo=$00
 scoreVarHi=$00:      scoreVarMed=$95:      scoreVarLo=$00
 scoreRobbedHi=$00:   scoreRobbedMed=$50:   scoreRobbedLo=$00

 rem ** Set Stats
 Stamina=$99:ownKnives=$25:Health=$50:Dexterity=$10:Charisma=$10

 rem ** Set value of 0 to the initial number of items that you own 
 ownMatches=$00:ownFirstAid=$00:ownShovel=$00:ownRope=$00
 ownCompass=$00:ownGPS=$00:ownFlare=$00:ownFuse=$00
 ownClothes=$00:ownCanteen=$00:ownTobacco=$00

 rem ** Set intial menu options
 menubarx=8:menubary=192:menuPos=0:menuColor=7

 rem ** Set initial joystick debounce value to 0
 debounce=0:JoyMoveUpDebounce=0:JoyMoveDownDebounce=0:JoyMoveLeftDebounce=0:JoyMoveRightDebounce=0

 rem ** Starting City, initial number of days in the game 
 rem ** Game Over flag, set to 1 when days remaining reaches 0
 City=1:daysleft=$31:GameOver=0:CharismaFlag=0:BackpackFlag=0

 rem ** Reset Statistics Variables
 statCountTraining=$00:statDexterityBonus=$00:statCharismaBonus=$00
 statCriminalsKilled=$00:statDaysRested=$00:statBankTransactions=$00

 rem ** Reset all flag variables to 0
 gosub resetFlags
 bankClosedFlag=0

 rem ** Jump to random price generator to set initial prices
 gosub PriceRandomization

 rem ** Set Initial Backpack Space
 scoreTotalBackpackSpaceHi=$00:scoreTotalBackpackSpaceMed=$00:scoreTotalBackpackSpaceLo=$50
 scoreUsedBackpackSpaceHi=$00: scoreUsedBackpackSpaceMed=$00: scoreUsedBackpackSpaceLo=$00
 rem ** Set initial menu cursor location
 rem menubarx=8:menubary=192
 
mainLoop
 drawwait
 clearscreen
 
 if daysleft=$01 then plotchars 'This is your Last Day!' 6 0 20
 if Health<$11 then plotchars 'Low Health!' 6 0 22
 ;if bankClosedFlag=1 then scoreBankHi=$00:scoreBankMed=$00:scoreBankLo=$00
 if bankClosedFlag=1 && City=2 then plotchars 'Bank was looted & destroyed!' 6 0 18
 if bankClosedFlag=1 && City=2 then plotchars 'Access to funds is lost.' 6 0 19

 rem Calculate Free Space remaining in Backpack
 gosub checkBackpackFree

 if switchreset then reboot

 rem ** Plot character sprite on-screen
 plotbanner dm_hero2 4 135 159
 rem ** Plots the character's eyes
 rem ** The @ sign was reassigned to two dots close together.
 ;plotchars '@' 5 146 21

 rem ** Plot prices, quantities, and stat values 
 gosub plotValues

 rem ** Check Left Joystick Button
 gosub JoystickLeftButton 

 rem ** Plot the menu selection sprite graphic. 
 plotsprite dm_menuicon 6 menubarx menubary

 rem ** Plot the common text on the top half of the screen.  It is re-used on other screens.
 gosub plotCommonScreenText 

 rem ** Bottom portion of the main screen 
 gosub plottopLeftLine

 rem ** Plot Main Menu
 plotchars '-*******************' 0 0 23:plotchars '********************-' 0 76 23
 plotchars 'Buy   Bank   Trav' 0 12 24:plotchars 'el  Train  Lender' 0 80 24
 plotchars 'Sell  Stats  Doct' 0 12 25:plotchars 'or  Fight  Rest' 0 80 25
 plotchars '#' 0 0 24:plotchars '#' 0 156 24
 plotchars '#' 0 0 25:plotchars '#' 0 156 25
 gosub plotBottomLine27

 rem ** Plot the Current City Name on-screen 
 rem ** It is re-used on multiple screens
 gosub plotCityName

 rem ** Debounce joystick movement on bottom main menu 
 gosub JoystickMoveUpDebounce:   gosub JoystickMoveDownDebounce
 gosub JoystickMoveLeftDebounce: gosub JoystickMoveRightDebounce

 rem ** Joystick movement for main menu 
 if JoyMoveUpDebounce=1 then JoyMoveUpDebounce=0:debounce=0:gosub sfxmenumove:gosub menumoveup
 if JoyMoveDownDebounce=1 then JoyMoveDownDebounce=0:debounce=0:gosub sfxmenumove:gosub menumovedown
 if JoyMoveLeftDebounce=1 then JoyMoveLeftDebounce=0:debounce=0:gosub sfxmenumove:gosub menumoveleft
 if JoyMoveRightDebounce=1 then JoyMoveRightDebounce=0:debounce=0:gosub sfxmenumove:gosub menumoveright

 rem | ------------------------------------------------------------------------------------|
 rem |        Chart of Where City Options are available, and City variable values          |
 rem | ------------------------------------------------------------------------------------|
 rem | Availability of City Options           |  City names and associated Variable Value  |
 rem | ---------------------------------------|--------------------------------------------|
 rem | menuPos   Menu Option  City Available  |  City Names   City Variable Value          |
 rem | -------   -----------  --------------  |  ----------   -----------------------------|
 rem | 5         Lender       Concord         |  New Vegas     1                           |
 rem | 9         Fight        *Any City*      |  Lost Angeles  2                           |
 rem | 1         Buy          *Any City*      |  New Salem     3                           |
 rem | 6         Sell         *Any City*      |  Concord       4                           |
 rem | 3         Travel       *Any City*      |  Diamond City  5                           |
 rem | 8         Doctor       New Vegas       |  Bedford       6                           |
 rem | 2         Bank         Lost Angeles    |                                            |
 rem | 7         Stats        *Any City*      |                                            |
 rem | 4         Train        New Salem       |                                            |
 rem | 10        Rest         Bedford         |                                            |
 rem | ---------------------------------------|--------------------------------------------|

 rem ** Detect Menu selection with button press
 if debounce<>1          then SkipFlags
 if menuPos=1            then gosub resetFlags:flagBuy=1
 if menuPos=2 && City=2  then gosub resetFlags:flagBank=1
 if menuPos=4 && City=3  then gosub resetFlags:flagTrain=1
 if menuPos=5 && City=4  then gosub resetFlags:flagLender=1
 if menuPos=6            then gosub resetFlags:flagSell=1
 if menuPos=7            then gosub resetFlags:flagStats=1
 if menuPos=8 && City=1  then gosub resetFlags:flagDoctor=1
 if menuPos=9            then gosub resetFlags:flagFight=1
 if menuPos=10 && City=6 then gosub resetFlags:flagRest=1
SkipFlags

 rem ** Jump to other Screens 
 if flagBuy=1    then playsfx sfx_menuselect:gosub screenBuy
 if flagSell=1   then playsfx sfx_menuselect:gosub screenSell
 if flagRest=1   then playsfx sfx_menuselect:gosub screenRest 
 if flagFight=1  then playsfx sfx_menuselect:gosub screenAttacked
 if flagDoctor=1 then playsfx sfx_menuselect:gosub screenDoctor
 if flagBank=1   then playsfx sfx_menuselect:gosub screenBank
 if flagLender=1 then playsfx sfx_menuselect:gosub screenLender
 if flagTrain=1  then playsfx sfx_menuselect:gosub screenTrain 
 if flagStats=1  then playsfx sfx_menuselect:gosub screenStats
 
 rem ** Process Menu Options based on City Location

 rem ** Buy [-Available in any City-]
 if menuPos<>1 then goto Skip2 
   gosub plotLeftFireButton16:  plotchars 'to buy an item.' 4 0 17
Skip2

 rem ** Bank Deposit [-Only availabe in Lost Angeles-]
 if menuPos<>2 then goto Skip3 
 rem 
 if City=2 && bankClosedFlag<>1 then plotchars 'Left fire to enter Bank' 4 0 16
 if City<>2 then plotchars 'Travel to Lost Angeles to' 6 0 16:plotchars 'visit the bank.' 6 0 17
Skip3

 rem ** Travel [-Available in any City-]
 if menuPos<>3 then goto Skip4
   if debounce=1 then gosub sfxoptionselect: debounce=0:gosub Travel
   plotchars 'Left fire travels to new city.' 4 0 16
Skip4

 rem ** Training Facility [-Only availabe in New Salem-]
 if menuPos<>4 then goto Skip5
 if City=3 then gosub plotLeftFireButton16
 if City=3 then plotchars 'to enter Training area.' 4 0 17
 if City<>3 then plotchars 'Travel to New Salem to train.' 6 0 16
Skip5

 rem ** Lender [-Only availabe in Concord-]
 if menuPos<>5 then goto Skip6 
 if City=4 then gosub plotLeftFireButton16
 if City=4 then plotchars 'to see the Lender.' 4 0 17
 if City<>4 then plotchars 'Travel to the city of Concord' 6 0 16:plotchars 'to visit the Lender.' 6 0 17
Skip6

 rem ** Sell [-Available in any City-]
 if menuPos<>6 then goto Skip7
   gosub plotLeftFireButton16: plotchars 'to sell items.' 4 0 17
Skip7 

 rem ** Statistics Screen [-Available in any City-]
 if menuPos<>7 then goto Skip8
   gosub plotLeftFireButton16: plotchars 'to view Stats.' 4 0 17
Skip8

 rem ** Doctor [-Only availabe in New Vegas-]
 if menuPos<>8 then goto Skip9
 if City=1 then gosub plotLeftFireButton16:plotchars 'to visit the Doctor.' 4 0 17
 if City<>1 then plotchars 'The Doctor is in New Vegas.' 6 0 16
Skip9

 rem ** Start a Fight [-Available in any City-]
 if menuPos<>9 then goto Skip10
 gosub plotLeftFireButton16:plotchars 'to start a fight.' 4 0 17
Skip10

 rem ** Rest [-Only availabe in Natick-]
 if menuPos<>10 then goto Skip11
 if City=6 then gosub plotLeftFireButton16:plotchars 'to rest a day.' 4 0 17
 if City<>6 then plotchars 'Travel to Bedford Falls to rest.' 6 0 16:rem plotchars 'to rest.' 6 0 16
Skip11

skipDraw1

 rem **Keep track of menu item that's selected based on X/Y value of selection sprite, then set MenuPos variable
 if menubarx=8 && menubary=192 then menuPos=1
 if menubarx=32 && menubary=192 then menuPos=2
 if menubarx=60 && menubary=192 then menuPos=3
 if menubarx=92 && menubary=192 then menuPos=4
 if menubarx=120 && menubary=192 then menuPos=5
 if menubarx=8 && menubary=200 then menuPos=6
 if menubarx=32 && menubary=200 then menuPos=7
 if menubarx=60 && menubary=200 then menuPos=8
 if menubarx=92 && menubary=200 then menuPos=9
 if menubarx=120 && menubary=200 then menuPos=10



 rem ** Check for end of Game (Run out of time or health)
 rem if daysleft=0 then GameOver=1
 if Health<$01 || daysleft=0 then goto theEnd
 
 rem Uncomment to test Death/GameOver Screen
 ; Death=1:goto screenStats

 rem Rollover Check
 rem 
 rem If you've achieved a score of $700,000 or more, and then have a transaction that gets you over $999,999  the 
 rem score will reset to $999,999.  This should keep the score at no higher than $999,999 for the game.
 rem It also sets a rollover flag to indicate that you have rolled the score over once.
 rem I don't think it would ever be possible to roll the score twice in one game.
 rem 
 rem The "rollover" subroutine is checked in the AddCredits and sellQuantity subroutines, where you actually earn money,
 rem   and the "rolloverCheck" variable is set to the current high byte of the credit score.
 rem 
 rem Then in the main loop it is compared, and the credit score is adjusted if needed.
 rem 

 if rolloverFlag=1 then goto theEnd
 rem plotvalue dm_scoredigits 6 rolloverFlag2 2 0 22
 if rolloverFlag=2 && rolloverCheck=$00 && scoreCreditsHi<$30 then scoreCreditsHi=$99:scoreCreditsMed=$99:scoreCreditsLo=$99:rolloverFlag=1
 drawscreen

 goto mainLoop

rollover
   rem if the score has at some point been higher than $70, then set a flag here.
   rem it otherwise immediately resets the rolloverCheck variable to zero when you roll over.
   rem when the flag is set, then set the score to 999,999 in the main loop.
   rem  This should finally solve the problem
   rem  Don't forget to uncomment the health and days left notifications and test them.
   rem
   rem Issue: A bank withdrawal of over $300,000 means that the rolloverCheck will never set the flag to 2
   rem Idea: Set maximum withdrawal amount to no more than $100,000 at a time. Updated and tested, works.
   rem
   rem Issue: If at any time in the game you make more than $300,000 at once - the rollover will NOT work.
   rem        If you earn $700,000 or more, and then your total amount of credits dips back below $9,999, it will trigger the rollover.
   rem           
   rem   Need to make sure it's not possible to earn more than $300,000 at once! 
   rem   The other issue of making hundreds of thousands and going back down to less than $10,000 is unlikely.
   rem   Document all price ranges and look at best case scenarios for making that much ore more. 

   if rolloverCheck>$70 then rolloverFlag=2
   rolloverCheck=scoreCreditsHi
   return

 rem End Main Loop 
 rem -------------------------------------------------------------------------------------------------------------


  rem ***************************************************
  rem **************** Doctor Subroutine ****************
  rem ***************************************************

screenDoctor
  gosub resetFlags
  debounce=0

  rem ** Generate Random Cost to visit the Doctor
  gosub RandomCost

  rem ** Calulate total
  ;if scoreTotalCostMed<$04 then goto screenDoctor

screenDoctorLoop
 drawwait
 clearscreen

 rem ** Verify that you have enough money
 creditvaluecheckHi=scoreTotalCostHi:creditvaluecheckMed=scoreTotalCostMed:creditvaluecheckLo=scoreTotalCostLo
 gosub verifyCredits 

 rem ** Plot prices, quantities, and stat values 
 gosub plotValues

 rem **Plot the common text on the top half of the screen.  It is re-used on other screens.
 gosub plotCommonScreenText 
 gosub plottopLeftLine
 gosub plotBottomLine27
 if Health>$98 then plotchars 'Health is full' 6 0 16:goto skipDocHeal
 plotchars 'Will you Spend $' 7 0 17 :plotchars 'to restore your' 7 84 17
 plotchars 'Health? ' 7 0 18
 plotvalue dm_scoredigits 7 scoreTotalCostMed 2 64 17
 plotvalue dm_scoredigits 7 scoreTotalCostLo 2 72 17
 ;plotbanner dm_doctor 0 120 176
 ;plotbanner dm_hero 6 140 176
 if CreditCompare=1 then plotchars 'Not enough Credits' 6 0 22:goto skipDocHeal
 plotchars 'Right fire confirms' 4 0 24
skipDocHeal
 plotchars 'Left fire exits' 4 0 23

 rem ** Plot the Current City Name on-screen 
 rem ** It is re-used on multiple screens
 gosub plotCityName

 rem **debounce fire buttons. It is activated when you release the button, not when you press it.
 gosub JoystickLeftButton:  gosub JoystickRightButton4

 if debounce=4 && Health<$99 && CreditCompare<>1 then menubarx=60:menubary=200:gosub sfxoptionselect:CreditCompare=0:debounce=0:flagDoctor=0:Health=$99:tempPriceMed=scoreTotalCostMed:tempPriceLo=scoreTotalCostLo:gosub SubtractCredits:return
SkipDoc1
 if debounce=1 then menubarx=60:menubary=200:gosub sfxmovesound:debounce=0:flagDoctor=0:CreditCompare=0:return

 drawscreen
 goto screenDoctorLoop

RandomCost
  temp1=22:temp2=95:gosub setRandomPrice
  scoreTotalCostMed=tempscorezLo 
  temp1=11:temp2=99:gosub setRandomPrice
  scoreTotalCostLo=tempscorezLo
  return 

RandomReward
  rem temp1=minimum temp2=maximum
  rem output is tempScorezLo
  temp1=22:temp2=95:gosub setRandomPrice
  scoreRewardMed=tempscorezLo 
  temp1=11:temp2=99:gosub setRandomPrice
  scoreRewardLo=tempscorezLo
  return 

  rem ********************************************************
  rem **************** Rest Screen Subroutine ****************
  rem ********************************************************

screenRest
 rem ** Set variables 
 debounce=0

screenRestLoop 
 drawwait
 clearscreen

 rem **Plot the common text on the top half of the screen.  It is re-used on other screens.
 gosub plotCommonScreenText 

 rem ** Plot the Current City Name on-screen 
 rem ** It is re-used on multiple screens
 gosub plotCityName

 rem ** Plot prices, quantities, and stat values 
 gosub plotValues
 gosub plotBottomLine27
 plotbanner dm_hero2 4 138 176

 gosub plottopLeftLine
 plotchars 'Rested for 1 day' 7 0 16
 plotchars 'Stamina & Food Up' 4 4 20
 plotchars 'Right fire continues' 7 0 25

 rem **debounce the fire button. 
 gosub JoystickRightButton 

 if debounce=1 then menubarx=120:menubary=200:gosub sfxoptionselect:goto FinishedResting 

 drawscreen
 goto screenRestLoop

FinishedResting
 flagRest=0:debounce=0
 
 rem ** Reduce remaining days by 1
 dec daysleft=daysleft-1
 
 rem ** Modify Stats
 if Stamina>$49 then Stamina=$99
 if Stamina<$50 then dec Stamina=Stamina+$40
 if scoreFoodLo>$59 then scoreFoodLo=$99
 if scoreFoodLo<$60 then dec scoreFoodLo=scoreFoodLo+$35

 dec statDaysRested=statDaysRested+$01

 return

  rem *************************************************
  rem **************** Bank Subroutine ****************
  rem *************************************************

screenBank
 menubary=160:menubarx=0:debounce=0

 tempscoreaHi=scoreCreditsHi:tempscoreaMed=scoreCreditsMed:tempscoreaLo=scoreCreditsLo
 tempscorebHi=scoreBankHi:tempscorebMed=scoreBankMed:tempscorebLo=scoreBankLo

screenBankLoop 
 drawwait
 clearscreen

 if scoreBankHi>$89 then bankClosedFlag=1

 if bankClosedFlag=1 then menubarx=32:menubary=192:flagBank=0:gosub sfxoptionselect:debounce=0:return
 
 ;if bankClosedFlag=1 then plotchars 'All deposits are lost.' 6 0 17
 ;if bankClosedFlag=1 then plotchars 'Left Fire Exits' 2 4 24
 ;if bankClosedFlag=1 then scoreBankHi=$00:scoreBankMed=$00:scoreBankLo=$00  

 rem ** reduces mid amount - could be a little confusing as to when it would work for game players.
 ;if tempscoreaMed>$00 && joy0left && menubary=160 then dec tempscoreaMed=tempscoreaMed-$01
 ;if tempscorebMed>$00 && joy0left && menubary=168 then dec tempscorebMed=tempscorebMed-$01

 gosub plotCommonScreenText 
 gosub plotCityName
 gosub plotValues
 gosub plottopLeftLine
 gosub plotBottomLine27
 plotsprite dm_menuicon 5 menubarx menubary
 
 ;if bankClosedFlag=1 then goto skipDisplay1
 plotchars 'Welcome to Lost Angeles Bank.' 7 4 16  
 plotchars 'We tell you what you can do!'   7 4 17 
 plotchars 'Deposit  $' 3 4 20
 plotchars 'Withdraw $' 3 4 21
 plotchars 'Left Fire cancels transfer' 2 4 24:plotchars ' Right Fire completes transfer' 2 0 25
 plotvalue dm_scoredigits 2 scorea 6 48 20
 plotvalue dm_scoredigits 2 scoreb 6 48 21

 rem If you have more than $100,000, then limit temp quantity to $100,000
 if tempscoreaHi>=$10 then tempscoreaHi=$10
 if tempscorebHi>=$10 then tempscorebHi=$10
 ;skipDisplay1

 gosub JoystickLeftButton
 gosub JoystickRightButton4 
 if joy0down then gosub bankmenudown
 if joy0up then gosub bankmenuup

 rem ** Exit the Bank  -  debounce=1 if you hit the left button, debounce=4 if you hit the right button.
 if debounce=1                 then menubarx=32:menubary=192:flagBank=0:gosub sfxoptionselect:debounce=0:return
 
 ;if bankClosedFlag=1 then goto skipDisplay2
 rem ** Deposit -----------------------------------------------------------------------------------------------------------------
 rem ** Variable Fixed amount Deposits
 ;if scoreCreditsHi>$00 then tempscoreaHi=$01:tempscoreaMed=$00:tempscoreaLo=$00
 ;if scoreCreditsHi=$00 && scoreCreditsMed>$00 then tempscoreaHi=$00:tempscoreaMed=$10:tempscoreaLo=$00
 if debounce=4 && menubary=160 then menubarx=32:menubary=192:gosub sfxoptionselect:dec statBankTransactions=statBankTransactions+1:debounce=0:tempPriceHi=tempscoreaHi:tempPriceMed=tempscoreaMed:tempPriceLo=tempscoreaLo:gosub AddBank:gosub SubtractCredits:gosub resetFlags:return
  
 rem ** Withdraw ----------------------------------------------------------------------------------------------------------------
 rem ** Variable Fixed amount Withdrawals
 ;if scoreBankHi>$01 then tempscorebHi=$01:tempscorebMed=$00:tempscorebLo=$00
 ;if scoreBankHi=$00 && scoreBankMed>$00 then tempscorebHi=$00:tempscorebMed=$01:tempscorebLo=$00
 if debounce=4 && menubary=168 then menubarx=32:menubary=192:gosub sfxoptionselect:dec statBankTransactions=statBankTransactions+1:debounce=0: tempPriceHi=tempscorebHi:tempPriceMed=tempscorebMed:tempPriceLo=tempscorebLo:gosub SubtractBank:gosub AddCredits:gosub resetFlags:return
 ;skipDisplay2

 drawscreen
 goto screenBankLoop
 
  rem ***************************************************
  rem **************** Lender Subroutine ****************
  rem ***************************************************

screenLender
 rem ** Set variables 
 debounce=0
 rem ** Deposit
 gosub resetTempScoreA
 scorea=0
 rem ** Change Menu graphic location
 menubarx=84:menubary=152:DebtCompare=9:CreditCompare=9:ZeroCompare=9

   rem Deposit match number
   rem if scoreCreditsHi>tempscoreaHi then tempscoreaHi=scoreCreditsHi
   rem      tempscoreaHi=scoreCreditsHi: tempscoreaMed=scoreCreditsMed: tempscoreaLo=scoreCreditsLo
   rem Withdrawl match number
   rem if scoreCreditsHi>tempscorebHi then tempscorebHi=scoreCreditsHi
   rem      tempscorebHi=scoreBankHi: tempscorebMed=scoreBankMed: tempscoreaLo=scoreBankLo

 rem if Debt > Credits then tempPrice=Credits
 rem if Credits > Debt then tempPrice=Debt

   rem if your Debt is greater than your credits
   if scoreDebtHi>scoreCreditsHi then tempscoreaHi=scoreCreditsHi
   if scoreDebtMed>scoreCreditsMed then tempscoreaMed=scoreCreditsMed
   if scoreDebtHi>scoreCreditsLo then tempscoreaLo=scoreCreditsLo

   rem if your debt is less than your credits
   if scoreCreditsHi>scoreDebtHi then tempscoreaHi=scoreDebtHi
   if scoreCreditsMed>scoreDebtMed then tempscoreaMed=scoreDebtMed
   if scoreCreditsHi>scoreDebtLo then tempscoreaLo=scoreDebtLo

screenLenderLoop 
 drawwait
 clearscreen

 rem **Plot the common text on the top half of the screen.  It is re-used on other screens.
 gosub plotCommonScreenText 

 rem ** Plot the Current City Name on-screen 
 rem ** It is re-used on multiple screens
 gosub plotCityName

 rem ** Plot prices, quantities, and stat values 
 gosub plotValues

 gosub plottopLeftLine
 plotchars 'Dont mess with me. Pay Up!' 6 0 16
 plotchars ' Pay Off: $' 4 0 20
 plotchars 'L/R to adjust' 0 0 24
 plotchars 'Right fire completes transfer.' 0 0 25
 gosub plotBottomLine27

 plotvalue dm_scoredigits 4 scorea 6 44 20

 if CreditCompare=1 then goto skipTransaction

 if joy0right && DebtCompare<>1 then scorea=scorea+100 
 if joy0left && tempscoreaMed>$00 then scorea=scorea-100: rem ** dont reduce value if you have less than 100 entered
skipTransaction

 rem **debounce the fire button. It's activated when you release the button, not when you press it.
 gosub JoystickRightButton 

 rem **Check for right fire button press    
 if debounce=1 then gosub sfxoptionselect:debounce=0:goto PayOff  

  rem ** Verify Credits & Debt
  rem ** ---------------------
  rem ** Need to verify that you don't choose to pay more than you have, or more than you owe.
  rem **  subroutine is used. 
  rem       INPUT:  creditvaluecheckHi, creditvaluecheckMed, creditvaluecheckLo
  rem               debtvaluecheckHi, debtvaluecheckMed, debtvaluecheckLo
  rem       OUTPUT: If CreditValue > ActualCredits then CreditCompare=1
  rem               If DebtValue > ActualDebt then DebtCompare=1
  rem ** Set subroutine variables to the number you've entered:
  creditvaluecheckHi=tempscoreaHi:creditvaluecheckMed=tempscoreaMed:creditvaluecheckLo=tempscoreaLo
  debtvaluecheckHi=tempscoreaHi:debtvaluecheckMed=tempscoreaMed:debtvaluecheckLo=tempscoreaLo
  rem ** Call subroutine to compare the values:
  gosub verifyCredits
  gosub verifyDebt
  rem ** If the compare value flag is set, then reduce the number you've entered by 100.
  if DebtCompare=1 then DebtCompare=0:scorea=scorea-100
  if CreditCompare=1 then CreditCompare=0:scorea=scorea-100

 drawscreen
 goto screenLenderLoop

PayOff

 gosub resetFlags
 tempPriceHi=tempscoreaHi: tempPriceMed=tempscoreaMed: tempPriceLo=tempscoreaLo
 gosub SubtractDebt
 gosub SubtractCredits
 menubarx=120:menubary=192

 rem 7/1/22
  tempPriceHi=$00: tempPriceMed=$00: tempPriceLo=$00
 return

verifyDebt
 asm
  ;   INPUT:  creditvaluecheckHi, creditvaluecheckMed, creditvaluecheckLo
  ;           debtvaluecheckHi, debtvaluecheckMed, debtvaluecheckLo
  ;   OUTPUT: If Credit Value > ActualCredits then CreditCompare=1
  ;           if Debt Value > ActualDebt then DebtCompare=1
  ;   A comparison which branches to AmountLarger if Amount >= Debt
  ;   scorea is the 24 bit number you are entering, score5 is the total amount of debt you have

           LDA debtvaluecheckHi          ; compare high bytes of Amount you want to transfer and the total amount of debt you have 
           CMP scoreDebtHi      
           BCC SkipCalc                  ; if debtvaluecheckHi < scoreDebtHi then Amount < Debt
           BNE AmountLargerDebt          ; if debtvaluecheckHi <> scoreDebtHi then Amount > Debt (so Amount >= Debt)
           LDA debtvaluecheckMed         ; compare middle bytes
           CMP scoreDebtMed
           BCC SkipCalc                  ; if debtvaluecheckMed < scoreDebtMed then Amount < Debt
           BNE AmountLargerDebt          ; if debtvaluecheckMed <> scoreDebtMed then Amount > Debt (so Amount >= Debt)
           LDA debtvaluecheckLo          ; compare low bytes
           CMP scoreDebtLo
           BCS SkipCalc                  ; if debtvaluecheckLo >= scoreDebtLo then Amount >= Debt
AmountLargerDebt
  	       LDA #1                        ; if the amount you entered is greater than the amount of debt you have, set a flag
           STA DebtCompare
SkipCalc
end 
 return

verifyCredits
 asm 
 ;   A comparison which branches to AmountLarger if Amount >= Credits
 ;   scorea is the 24 bit number you are entering, score5 is the total amount of Credits you have

           LDA creditvaluecheckHi       ; compare high bytes of Amount you want to transfer and the total amount of Credits you have 
           CMP scoreCreditsHi      
           BCC SkipCreditCalc            ; if creditvaluecheckHi < scoreCreditsHi then Amount < Credits
           BNE AmountLargerCredits       ; if creditvaluecheckHi <> scoreCreditsHi then Amount > Credits (so Amount >= Credits)
           LDA creditvaluecheckMed      ; compare middle bytes
           CMP scoreCreditsMed
           BCC SkipCreditCalc            ; if creditvaluecheckMed < scoreCreditsMed then Amount < Credits
           BNE AmountLargerCredits       ; if creditvaluecheckMed <> scoreCreditsMed then Amount > Credits (so Amount >= Credits)
           LDA creditvaluecheckLo        ; compare low bytes
           CMP scoreCreditsLo 
           BCS SkipCreditCalc            ; if creditvaluecheckLo >= scoreCreditsLo then Amount >= Credits
AmountLargerCredits
  	       LDA #1                        ; if the amount you entered is greater than the amount of money you have, set a flag
           STA CreditCompare
SkipCreditCalc 
end
 return

verifyBank
 asm 
 ; Input:  creditvaluecheckHi
 ;         creditvaluecheckMed
 ;         creditvaluecheckLo
 ; Output: BankFlag {value of 1 or 0}
 ; 
 ;   A comparison which branches to AmountLarger if Amount >= Credits
 ;   scoreb is the 24 bit number you are entering, score5 is the total amount of Bank Credits you have

           LDA bankvaluecheckHi        ; compare high bytes of Amount you want to transfer and the total amount of Credits you have 
           CMP scoreBankHi      
           BCC SkipBankCalc              ; if creditvaluecheckHi < scoreBankHi then Amount < Credits
           BNE AmountLargerBank          ; if creditvaluecheckHi <> scoreBankHi then Amount > Credits (so Amount >= Credits)
           LDA bankvaluecheckMed       ; compare middle bytes
           CMP scoreBankMed
           BCC SkipBankCalc              ; if creditvaluecheckMed < scoreBankMed then Amount < Credits
           BNE AmountLargerBank          ; if creditvaluecheckMed <> scoreBankMed then Amount > Credits (so Amount >= Credits)
           LDA bankvaluecheckLo        ; compare low bytes
           CMP scoreBankLo 
           BCS SkipBankCalc              ; if creditvaluecheckLo >= scoreBankLo then Amount >= Credits
AmountLargerBank
  	       LDA #1                        ; if the amount you entered is greater than the amount of money you have, set a flag
           STA BankCompare
SkipBankCalc 
end
 return

  rem **********************************************************
  rem **************** Travel Screen Subroutine ****************
  rem **********************************************************
 
Travel

 rem ** Initialize Variables Here
 debounce=0:JoyMoveDownDebounce=0
 
travelLoop 
 rem screenTravel 
 
 drawwait
 clearscreen
 flagTravelLine=1

 rem displays line above map, adjusts Y location for Travel screen vs main loop
 gosub plottopLeftLine

 rem display bottom line below map, again adjusted between main loop and travel loop
 gosub plotBottomLine27

 rem **debounce the fire button. It's activated when you release the button, not when you press it.
 gosub JoystickRightButton 

 rem ** Begin travel sequence if fire button is pressed
 if debounce=1 && flagTravel<11 && flagTravel>17 then debounce=0:menuPos=1:dec daysleft=daysleft-1:gosub sfxoptionselect:goto TravelEvents 
 if debounce=1 then debounce=0:menuPos=1:gosub PriceRandomization:dec daysleft=daysleft-1:gosub sfxoptionselect:goto TravelEvents 

 rem ** Debounce Joystick movement. The cursor will move when you release the joystick, rather than when you move it.
 gosub JoystickMoveUpDebounce:   gosub JoystickMoveDownDebounce
 gosub JoystickMoveLeftDebounce: gosub JoystickMoveRightDebounce

 rem ** Joystick
 if JoyMoveDownDebounce=1 then JoyMoveDownDebounce=0:gosub sfxmovesound:gosub travelmenumovedown
 if JoyMoveUpDebounce=1 then JoyMoveUpDebounce=0:gosub sfxmovesound:gosub travelmenumoveup
 if JoyMoveRightDebounce=1 then JoyMoveRightDebounce=0:gosub sfxmovesound:gosub travelmenumovedown
 if JoyMoveLeftDebounce=1 then JoyMoveLeftDebounce=0:gosub sfxmovesound:gosub travelmenumoveup

 gosub plotTravelMap
 gosub plotTopLine0
 plotchars 'Pick a destination &' 4 0 2 
 plotchars 'Press right fire' 4 0 3 
 rem ** This highlights the selected city
 if City=1 then menuColor1=3:menuColor2=5:menuColor3=5:menuColor4=5:menuColor5=5:menuColor6=5:plotchars '***' 3 15 13
 if City=2 then menuColor1=5:menuColor2=3:menuColor3=5:menuColor4=5:menuColor5=5:menuColor6=5:plotchars '***' 3 0 26
 if City=3 then menuColor1=5:menuColor2=5:menuColor3=3:menuColor4=5:menuColor5=5:menuColor6=5:plotchars '***' 3 52 26 
 if City=4 then menuColor1=5:menuColor2=5:menuColor3=5:menuColor4=3:menuColor5=5:menuColor6=5:plotchars '***' 3 76 22
 if City=5 then menuColor1=5:menuColor2=5:menuColor3=5:menuColor4=5:menuColor5=3:menuColor6=5:plotchars '***' 3 82 17
 if City=6 then menuColor1=5:menuColor2=5:menuColor3=5:menuColor4=5:menuColor5=5:menuColor6=3:plotchars '**' 3 119 24

 drawscreen

 goto travelLoop

  rem ***********************************************************
  rem **************** Travel Events Subroutine *****************
  rem ***********************************************************

TravelEvents
  debounce=0
  flagTravel=1

  rem ** Generate Random amount of money that may be found travelling 
  rem    RandCashLo, RandCashMed, RandMoney
  temp1=0:temp2=0:gosub setRandomPrice
  RandCashMed=rand&1
  temp1=0:temp2=9:gosub setRandomPrice
  RandCashLo=tempscorezLo
  rem ** Calulate total
  dec RandMoney=RandCashMed+RandCashLo
  heroX=160
TravelEventsLoop
 drawwait
 clearscreen
 
 gosub plotBottomLine27
 gosub plottopLeftLine
 gosub plotTravelMap
 gosub plotTopLine0

 plotchars 'You travel down the dusty road.' 3 0 2 

 if heroX=0 then goto skipHero1
 if heroX>0 then heroX=heroX-1
 plotbanner dm_hero2 4 heroX 52
skipHero1

 rem **Random number triggers Random events
 
 if flagTravel<>1 then SkipRandEvent
 RandEvent=rand&7
 if RandEvent=0 then flagTravel=10:  rem ** Pricing Event (+/-)  -->  Pricing events are then further randomized
 if RandEvent=1 then flagTravel=20:  rem ** You are attacked     -->  Attack events are then further randomized
 if RandEvent=2 then flagTravel=30:  rem ** You find some money
 if RandEvent=3 then flagTravel=40:  rem ** You are given some stuff
 if RandEvent=4 then flagTravel=50:  rem ** Merchant appears 
 if RandEvent=5 then flagTravel=60:  rem ** You find a knife
 if RandEvent=6 then flagTravel=70:  rem ** Uneventful trip - changed  from 70 to 50 for DEBUG, make merchant appear more often
 if RandEvent=7 then flagTravel=80:  rem ** You find some food
SkipRandEvent

 rem ** Price Event
 rem ** This will randomly increase or decrease prices on some items
 if flagTravel<>10 then goto skipEvent1
   flagTravel=9: rem ** Set to 9 to trigger Random Price Event
   rem ** Setting it to 9 then randomly resets it to a range of 11-18 for various events
skipEvent1

 rem ** Attacked
 rem ** This will gain you money and randomly decrease your health
 rem ** Your knife may be broken or dropped (lost)
 if flagTravel<>20 then goto skipEvent2 
   flagTravel=19 
skipEvent2

 rem ** Found Money
 rem ** You discover a random amount of money
 if flagTravel<>30 then goto skipEvent3
   tempPriceMed=$22:tempPriceLo=$00:flagTravel=203:gosub AddCredits
skipEvent3
   if flagTravel=203 then plotchars 'You found $2200 on a corpse' 4 0 5 

 rem ** You are given something random
 if flagTravel<>40 then goto skipEvent4
   flagTravel=41
   ;if ownKnives<$91 then dec ownKnives=ownKnives+4
   ;if scoreCreditsMed>$05 then tempPriceHi=$00:tempPriceMed=$05:tempPriceLo=$00:gosub Add-Credits
   if scoreCreditsHi>$98 then goto skipEvent4 ; if you have $980,000 or more in credits, skip the bonus, you don't need it!
   tempPriceHi=$00:tempPriceMed=$15:tempPriceLo=$00:gosub AddBank
   if scoreFoodLo<$89 then dec scoreFoodLo=scoreFoodLo+$10
skipEvent4
   if flagTravel=41 then plotchars 'You earned a $1500 deposit' 4 0 4:plotchars 'in the Bank loyalty program.' 4 0 5
   if flagTravel=41 then plotchars 'plus interest!' 4 0 6
   
 rem ** Death Merchant
 rem ** Merchant appears, allowing you to buy stuff 
 if flagTravel<>50 then goto skipEvent5
  flagTravel=51: rem setting it to 51 will jump to the merchant loop at the end of this sub 
skipEvent5

 rem ** Found Knife
 if flagTravel<>60 then goto skipEvent6
   if ownKnives<$91 then dec ownKnives=ownKnives+8:flagTravel=201
skipEvent6
   if flagTravel=201 then plotchars 'You found 8 knives' 4 0 5

 rem ** Nothing Happens or you're robbed                   
 if flagTravel<>70 then goto skipEvent7
 rem ** Mercy Rule:  You won't be robbed during the first few days of the game.
 if daysleft>$28 then goto skipEvent7b
   rem ** Generate Random number for the amount you might get robbed
   ;gosub RandomCost
   creditvaluecheckMed=scoreRobbedMed:creditvaluecheckLo=scoreRobbedLo
   rem ** Verify that the random amount isn't more than the amount of money you current have
   gosub verifyCredits
   rem ** Deduct credits if applicable
   ;if CreditCompare<>1 then flagTravel=71:tempPriceMed=scoreRobbedMed:tempPriceLo=scoreRobbedLo:gosub SubtractCredits
   if CreditCompare<>1 then flagTravel=71:tempPriceHi=$00:tempPriceMed=$50:scoreRobbedMed=$50:tempPriceLo=$00:scoreRobbedLo=$00:gosub SubtractCredits ; works 1.25c
skipEvent7
  if flagTravel<>71 then goto skipEvent7b 
  plotchars 'You were robbed!' 4 0 4
  ;plotvalue dm_scoredigits 4 scoreRobbedMed 4 4 5
  plotchars '$5000 is gone!' 4 0 5
skipEvent7b
  if flagTravel=70 then plotchars 'You had an uneventful trip' 0 0 5

 rem ** Found Food
 if flagTravel<>80 then goto skipEvent8
   rem BUGCHECK - don't add food if you already have 99!
  if scoreFoodLo<$90 then dec scoreFoodLo=scoreFoodLo+$10:flagTravel=200
skipEvent8
   if flagTravel=200 then plotchars 'You found 10 rations of Food' 4 0 5 
 if flagAttacked=1 then goto skipMsg1
 gosub plotRightFireButton8
skipMsg1

 rem ** Attack Randomization
 rem ** This section runs the RandomEvent randomizer to run the Random Attack Sequence.
 if flagTravel<>19 then goto SkipEvent19
 RandomEvent=rand&7
 if RandomEvent=0 then flagTravel=21:rem    Escaped
 if RandomEvent=1 then flagTravel=22:rem    Fight      5 Food Stolen
 if RandomEvent=2 then flagTravel=23:rem    Escaped
 if RandomEvent=3 then flagTravel=24:rem    Fight 
 if RandomEvent=4 then flagTravel=25:rem    Escaped    Lose 5 Stamina
 if RandomEvent=5 then flagTravel=26:rem    Escaped    Lose 3 Stamina
 if RandomEvent=6 then flagTravel=27:rem    Fight 
SkipEvent19

  rem ** Attacked - Escaped
  if flagTravel<>21 then goto SkipTravel21
   plotchars 'A gang of criminals chased you,' 0 0 4
   plotchars 'but you escaped.' 0 0 5
   flagAttacked=0
SkipTravel21

  rem ** Attacked - Forced to Fight
  if flagTravel<>22 then goto SkipTravel22
   rem BUGCHECK - don't reduce food if you have less than 5!
   if scoreFoodLo>$04 then dec scoreFoodLo=scoreFoodLo-$05
   flagTravel=204:flagAttacked=1
SkipTravel22
    if flagTravel<>204 then goto Skip204
      plotchars 'You ran, but the outlaws caught' 0 0 4
      plotchars 'up and stole 5 food' 0 0 5
      gosub plotRightFireButton8
Skip204

  rem ** Attacked - Escaped
  if flagTravel<>23 then goto SkipTravel23
   plotchars 'You heard them coming' 0 0 4
   plotchars 'Left fire to run away' 0 0 5
   gosub plotRightFireButton8
  flagAttacked=1
SkipTravel23

  rem ** Attacked - Forced to Fight
  if flagTravel<>24 then goto SkipTravel24
   plotchars 'You were ambushed' 0 0 5
   gosub plotRightFireButton8
   flagAttacked=1
SkipTravel24

  rem ** Attacked - Escaped 
  if flagTravel<>25 then goto SkipTravel25
   rem BUGCHECK - Dont reduce Stamina by 5 if you have less than 5!
   if Stamina>$05 then dec Stamina=Stamina-6:flagTravel=205:flagAttacked=0
SkipTravel25
    if flagTravel<>205 then goto Skip205
      plotchars 'A group of outlaws' 0 0 4
      plotchars 'chased you' 0 0 5
      plotchars 'Stamina down 6' 0 0 6
Skip205

  rem ** Attacked - Escaped 
  if flagTravel<>26 then goto SkipTravel26
   if Stamina>$02 then dec Stamina=Stamina-4:flagAttacked=0:flagTravel=206
SkipTravel26
   if flagTravel<>206 then goto Skip206
   plotchars 'Capture eluded after a chase' 0 0 4
   plotchars 'Stamina down 4' 0 0 6
Skip206

  rem ** Attacked - Forced to Fight
  if flagTravel<>27 then goto SkipTravel27
   plotchars 'A group of thieves surprised you' 0 0 5
   gosub plotRightFireButton8
   flagAttacked=1
SkipTravel27

 rem ** Adjust Item Prices
 rem ** This section runs the RandomEvent randomizer to alter Prices,
 rem ** Some items may increase or decrease in price
 if flagTravel<>9 then goto SkipEvent9

 RandomEvent=rand&7
 if RandomEvent=0 then flagTravel=11:rem   Matches Price Drop
 if RandomEvent=1 then flagTravel=12:rem   Matches Price Rise
 if RandomEvent=2 then flagTravel=13:rem   Rope Price Drops
 if RandomEvent=3 then flagTravel=14:rem   Canteens Price Rise
 if RandomEvent=4 then flagTravel=15:rem   Canteens Price Drop 
 if RandomEvent=5 then flagTravel=16:rem   Tobacco Price Rises
 if RandomEvent=6 then flagTravel=17:rem   Tobacco Price Drops
SkipEvent9

 rem ** Matches Price Drop
 if flagTravel<>11 then goto SkipTravel11
   gosub textCaravan
   plotchars 'with matches.' 0 0 5
   gosub textPricesPlummet
   gosub PriceRandomization 
SkipTravel11

 rem ** Rope Price Drop
 if flagTravel<>12 then goto SkipTravel12
   gosub textCaravan
   plotchars 'with Rope.' 0 0 5
   gosub textPricesPlummet
   gosub PriceRandomization 
SkipTravel12

 rem ** Canteen Price Increase
 if flagTravel<>13 then goto SkipTravel13
   gosub textCriminals
   plotchars 'and stole dozens of canteens.' 0 0 5
   gosub textPricesSkyrocket
   gosub PriceRandomization 
SkipTravel13

 rem ** Tobacco Price Increase
 if flagTravel<>14 then goto SkipTravel14
   gosub textCriminals
   plotchars 'and stole a shipment of Tobacco.' 0 0 5
   gosub textPricesSkyrocket
   gosub PriceRandomization 
SkipTravel14

 rem ** Matches Price Increase
 if flagTravel<>15 then goto SkipTravel15
   gosub textCriminals
   plotchars 'and stole scores of matches.' 0 0 5
   gosub textPricesSkyrocket
   gosub PriceRandomization 
SkipTravel15

 rem ** Canteen Price Decrease
 if flagTravel<>16 then goto SkipTravel16
   gosub textCaravan
   plotchars 'with canteens.' 0 0 5
   gosub textPricesPlummet
   gosub PriceRandomization 
SkipTravel16

 rem ** Tobacco Price Decrease
 if flagTravel<>17 then goto SkipTravel17
   gosub textCaravan
   plotchars 'with Tobacco.' 0 0 5
   gosub textPricesPlummet
   gosub PriceRandomization 
SkipTravel17

 rem ** Clothing Price Decrease 
 if flagTravel<>18 then goto SkipTravel18
   gosub textCaravan
   plotchars 'with clothes.' 0 0 5
   gosub textPricesPlummet
   gosub PriceRandomization 
SkipTravel18

 if flagAttacked=1 then gosub screenAttacked
 if flagTravel=51 then gosub screenMerchant

 rem **debounce the fire button. It's activated when you release the button, not when you press it.
 gosub JoystickRightButton 
 if debounce=1 then CreditCompare=0:gosub sfxoptionselect:goto FinishTheDay

 drawscreen

 goto TravelEventsLoop

textCaravan
   plotchars 'A caravan restocked the shelves' 0 0 4
   return
textPricesPlummet
   plotchars 'Prices plummet!' 0 0 6
   return
textPricesSkyrocket
   plotchars 'Prices skyrocket!' 0 0 6
   return
textCriminals
   plotchars 'The market was raided!' 0 0 4
   return

  rem ******************************************************
  rem **************** Training Subroutine *****************
  rem ******************************************************

  rem 1.2c BUG.  bought a whole bunch of training got dex up to 95, then fights awarded me +1 regardless of my current dex number.  Had 99, won a fight, went to 0.

screenTrain
  gosub resetFlags
  debounce=0:tempPriceMed=$00:tempPriceLo=$00:CreditCompare=0:lineColor=3
  trainingFlag=1
  rem ** Generate Random Cost for Trainer
  gosub RandomCost
  heroX=120

screenTrainLoop
 drawwait
 clearscreen

 rem ** Verify that you have enough money
 creditvaluecheckHi=scoreTotalCostHi:creditvaluecheckMed=scoreTotalCostMed:creditvaluecheckLo=scoreTotalCostLo
 gosub verifyCredits 

 rem **Plots solid line on line 1 and 26
 gosub plotTopLine0
 gosub plotBottomLine27
 gosub altBottom

 rem ** If your dexterity is already 99 or you have less than the cost, trainer is unavailable and you can't purchase training.
 if Dexterity>$93 then plotchars 'Dexterity too high' 2 0 4:goto skipTrain1
 plotchars 'A soldier offers to train you' 4 0 4
 plotchars 'for $' 4 0 5
 plotvalue dm_scoredigits 4 scoreTotalCostMed 4 20 5

 if CreditCompare=1 then plotchars 'Not enough Credits' 2 0 10:goto skipTrain1:goto skipTrain1
 plotchars 'Right Fire Pays' 7 0 25
skipTrain1

 ;gosub plottopLeftLine 
 ;gosub plotBottomLine19
 plotchars 'Use knife training' 6 0 7
 plotchars 'to boost dexterity' 6 0 8
 plotchars 'Left Fire declines' 7 0 24

 rem **debounce the fire button. It's activated when you release the button, not when you press it.
 gosub JoystickLeftButton:if debounce=1 then heroX=100:menubarx=92:menubary=192:gosub sfxoptionselect:debounce=0:CreditCompare=0:return

 if joy0fire0 then debounce=3
 if !joy0fire0 && debounce=3 then debounce=4

 rem ** Deduct Money, add to training count, increase dexterity
 rem ** First check that your dexterity isn't already maxed out, and that you have enough money to pay for the training.
 if Dexterity>$93 then goto skipDexAdd

 if CreditCompare=1 then goto skipDexAdd
 if debounce=4 then menubarx=92:menubary=192:heroX=100:gosub sfxhit:CreditCompare=0:debounce=0:tempPriceMed=scoreTotalCostMed:tempPriceLo=scoreTotalCostLo:dec statCountTraining=statCountTraining+1:dec statDexterityBonus=statDexterityBonus+5:dec Dexterity=Dexterity+5:gosub SubtractCredits:gosub resetFlags:return
skipDexAdd

 if heroX>50 then heroX=heroX-1
 plotbanner dm_criminal4 0 20 156
 plotbanner dm_hero2 4 heroX 156

 drawscreen
 goto screenTrainLoop
 
  rem ******************************************************
  rem **************** Merchant Subroutine *****************
  rem ******************************************************
  
screenMerchant
 gosub resetFlags
 debounce=0:menubarx=75:menubary=88:CharismaFlag=0:scorea=0:lineColor=3
 heroX=135
 trainingFlag=0
screenMerchantLoop
 drawwait
 clearscreen

 rem Calculate Free Space remaining in Backpack
 gosub checkBackpackFree

 tempPriceHi=$00

 rem **Plots solid line on line 1 and 26
 gosub plotTopLine0
 gosub plotBottomLine27

 plotchars 'Backpack:   /' 0 8 5
 plotvalue dm_scoredigits 0 scoreUsedBackpackSpaceLo 2 48 5:  rem **Space Consumed
 plotvalue dm_scoredigits 0 scoreTotalBackpackSpaceLo 2 60 5:  rem **Total Space

 plotchars 'Credits: $' 0 8 7
 plotvalue dm_scoredigits 0 score1 6 48 7:  rem **Credits ($Money)

 rem ** For debugging, shows CharismaFlag value on-screen
 ;plotvalue dm_scoredigits 3 CharismaFlag 2 118 7

 plotchars 'The Death Merchant offers you' 5 4 2
 plotchars 'items to buy' 5 4 3
 plotchars 'Item              Cost' 7 8 9
 plotchars 'Canteen           $100' 4 8 11
 plotchars 'Knives            $500' 4 8 12
 plotchars 'Rope              $1500' 4 8 13
 plotchars 'Food              $100' 4 8 14
 plotchars 'Large Backpack    $9500' 4 8 15
 gosub plotExit24
 rem gosub plotBottomLine19
 plotchars 'Right Fire Buys' 4 0 25

 if heroX>35 then heroX=heroX-1
 plotsprite dm_icon_rope  7 17 181
 plotsprite dm_icon_canteen 6 13 181
 plotbanner dm_merchant 0 20 156
 plotbanner dm_hero2 4 heroX 156
altBottom
 plotchars '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' 3 0 23:plotchars '%%%%%%%%' 3 128 23
 if trainingFlag=1 then return
 
 rem **Plot the menu selection sprite graphic.
 plotsprite dm_menuicon 6 menubarx menubary
 
 gosub JoystickMoveUpDebounce
 gosub JoystickMoveDownDebounce

 rem ** Joystick movement
 if JoyMoveUpDebounce=1 then CreditCompare=0:JoyMoveUpDebounce=0: gosub clearQuantities:gosub sfxoptionselect:menubary=menubary-8
 if JoyMoveDownDebounce=1 then CreditCompare=0:JoyMoveDownDebounce=0:gosub clearQuantities:gosub sfxoptionselect:menubary=menubary+8

 rem ** Prevent scrolling off the top or bottom of the menu
 if menubary<88 then menubary=88
 if menubary>120 then menubary=120

 rem ** Debounce the fire button. It's activated when you release the button, not when you press it.
 gosub JoystickLeftButton
 gosub JoystickRightButton4

 rem note If backpack flag is 0, scoreTotalBackpackSpaceLo is 50
 rem note If backpack flag is 1, scoreTotalBackpackSpaceLo is 99

 rem ** Check that you have enough backpack space before allowing purchase.  If you do not, skip purchase.
 rem ** It will also limit inventory you can purchase

 if menubary=88  && backpackFree<$03                          then gosub buyStopped:goto SkipMerchant1:        rem Canteen Free Space Check
    if menubary=88  && ownCanteen>$42                         then gosub buyStopped:goto SkipMerchant1:        rem Canteen Inventory Check
 if menubary=96  && ownKnives>$60                             then gosub buyStopped:goto SkipMerchant1:        rem Knives Inventory Check
 if menubary=104 && backpackFree<$03                          then gosub buyStopped:goto SkipMerchant1:        rem Rope Free Space Check
    if menubary=104 && ownRope>$09                            then gosub buyStopped:goto SkipMerchant1:        rem Rope Inventory Check
 if menubary=112 && scoreFoodLo>$60                           then gosub buyStopped:goto SkipMerchant1:        rem Food Inventory Check
 if menubary=120 && BackpackFlag=1                            then gosub buyBackpackDenied:goto SkipMerchant1: rem Backpack Expansion Check

 rem ** Purchase items
 
 gosub checkBackpackFree 

 if menubary=88 then tempPriceMed=$01:tempPriceLo=$00: gosub merchantVerify: rem Canteen
 if CreditCompare=1 then gosub notEnoughCredits2:goto skipNextBuy1 
 rem if CreditCompare=0 then gosub notEnoughCredits:goto skipNextBuy1 
 if debounce=4 && menubary=88 && ownCanteen<$99 && backpackFree>$01 then debounce=0:gosub merchantBuy:dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+$01:dec ownCanteen=ownCanteen+$01
skipNextBuy1

 if menubary=96  then tempPriceMed=$05:tempPriceLo=$00: gosub merchantVerify: rem Knives
 if CreditCompare=1 then CreditCompare=0:gosub notEnoughCredits2:goto skipNextBuy2
 rem if CreditCompare=0 then gosub notEnoughCredits:goto skipNextBuy2 
 if debounce=4 && menubary=96 && ownKnives<$99 && CreditCompare<>1 then debounce=0:gosub merchantBuy:dec ownKnives=ownKnives+1
skipNextBuy2

 if menubary=104 then tempPriceMed=$15:tempPriceLo=$00: gosub merchantVerify: rem Rope
 if CreditCompare=1 then CreditCompare=0:gosub notEnoughCredits2:goto skipNextBuy3
 rem if CreditCompare=0 then gosub notEnoughCredits:goto skipNextBuy3
 if debounce=4 && menubary=104 && ownRope<$99 && CreditCompare<>1 && backpackFree>$01 then debounce=0:gosub merchantBuy:dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+$01:dec ownRope=ownRope+$01
skipNextBuy3

 if menubary=112 then tempPriceMed=$01:tempPriceLo=$00: gosub merchantVerify: rem Food
 if CreditCompare=1 then CreditCompare=0:gosub notEnoughCredits2:goto skipNextBuy4
 rem if CreditCompare=0 then gosub notEnoughCredits:goto skipNextBuy4
 if debounce=4 && menubary=112 && scoreFoodLo<$99 && CreditCompare<>1 then debounce=0:gosub merchantBuy:dec scoreFoodLo=scoreFoodLo+$01
skipNextBuy4

 if menubary=120 then tempPriceMed=$95:tempPriceLo=$00: gosub merchantVerify: rem Backpack 
 if CreditCompare=1 then CreditCompare=0:gosub notEnoughCredits2:goto skipNextBuy5
 rem if CreditCompare=0 then gosub notEnoughCredits:goto skipNextBuy5
 if debounce=4 && menubary=120 && CreditCompare<>1 then debounce=0:gosub merchantBuy:BackpackFlag=1:scoreTotalBackpackSpaceLo=$99:rem dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-$49
skipNextBuy5

SkipMerchant1
  
 rem if CharismaFlag=2 then plotchars 'Free items due to your Charisma,' 7 0 21:plotchars 'added to your backpack!' 7 0 22


 rem ** Left Button Exits the Merchant
 if debounce=1 then gosub sfxoptionselect:debounce=0:menubarx=60:menubary=192:CreditCompare=0:heroX=200:return

 drawscreen
 goto screenMerchantLoop

notEnoughCredits
 plotchars 'Not enough Credits' 6 8 21
 return

notEnoughCredits2
 plotchars 'Not enough Credits' 6 8 18
 return

merchantVerify
  creditvaluecheckHi=tempPriceHi:creditvaluecheckMed=tempPriceMed:creditvaluecheckLo=tempPriceLo
  gosub verifyCredits
  return

merchantBuy
  debounce=0:dec Charisma=Charisma+1:gosub SubtractCredits:CharismaFlag=1:gosub CharismaModifier
  return 

plotBottomLine19
 plotchars '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' lineColor 0 19:plotchars '%%%%%%%%%' lineColor 124 19
 return

checkBackpackFree
 dec backpackFree=scoreTotalBackpackSpaceLo-scoreUsedBackpackSpaceLo

  rem  plotvalue dm_scoredigits 0 scoreUsedBackpackSpaceLo 2 48 9:  rem **Space Consumed
  rem  plotvalue dm_scoredigits 0 scoreTotalBackpackSpaceLo 2 59 9:  rem **Space
  rem 
  rem ** scoreC (Used Backpack Space)
  rem dim scorec=var97
  rem  dim scoreUsedBackpackSpaceHi=scorec :dim scoreUsedBackpackSpaceMed=scorec+1 :dim scoreUsedBackpackSpaceLo=scorec+2 
 rem ** score6 (Total Backpack Space)
  rem dim score6=$2699 
  rem dim scoreTotalBackpackSpaceHi=score6:dim scoreTotalBackpackSpaceMed=score6+1:dim scoreTotalBackpackSpaceLo=score6+1
  
 return

  rem **************************************************************
  rem **************** Fight / Attacked Subroutine *****************
  rem **************************************************************

  rem -...Winning increases Dexterity (Start with 10, Training increases it by 2 each time, winning a battle increases it by 1)
  rem -...higher dexterity increases odds of winning the fight (increase by 5% at 5 point increments up to 25.)
  rem -...fight decreases Stamina by 5.

screenAttacked

 gosub resetFlags
   RandEnemies=rand&7
   if RandEnemies<$03 || RandEnemies>$06 then goto screenAttacked
 debounce=0
 flagAttacked=0
 gosub AttackRandomization
 DisplayFlag=0

 rem ** Initial location of Hero
 heroMove=30

 rem ** For checking odds of escape
 escapeRand=rand&7
 escapeFlag=0

screenAttackedLoop
 drawwait
 clearscreen

 rem ** Plot Top and Bottom lines 
 gosub plotTopLine0
 gosub plotBottomLine27

 rem added 1.25d
 if Health<$01 then Death=1:goto theEnd

 plotchars 'Gang Encounter' 3 0 2                
 plotchars 'Knives        /99' 5 0 5    :plotchars 'Criminals' 4 84 5
 plotchars 'Health        /99' 5 0 6                     
 plotchars 'Stamina       /99' 6 0 7    :plotchars 'Gangs Killed' 4 84 7   
 plotchars 'Dexterity     /99' 6 0 8    :plotchars 'Dex Bonus' 4 84 8                          
 gosub plottopLeftLine 

 gosub plotExit24 
 if Stamina>$00 && ownKnives>$01 && RandEnemies>$01 && FightingFlag<>82 then plotchars 'Right fire to fight' 4 0 25

 if DisplayFlag<>82 then goto F8   
   plotchars 'Entire Gang Killed!' 7 78 16
   if Dexterity<$99 then plotchars '1 Dexterity Bonus' 3 78 18
   plotchars '$     Credits Found' 3 78 20
   plotchars 'Extra Knives Found' 3 78 22
   plotvalue dm_scoredigits 3 tempPriceMed 2 82 20
   plotvalue dm_scoredigits 3 tempPriceLo  2 90 20
F8

 plotvalue dm_scoredigits 5 ownKnives 2 48 5:     rem ** Knives
 plotvalue dm_scoredigits 5 Health 2 48 6:        rem ** Health
 plotvalue dm_scoredigits 6 Stamina 2 48 7:       rem ** Stamina
 plotvalue dm_scoredigits 6 Dexterity 2 48 8:     rem ** Dexterity
 plotvalue dm_scoredigits 2 RandEnemies 2 138 5:  rem ** Rand# of Criminals (3-6)
 plotvalue dm_scoredigits 6 statCriminalsKilled 2 138 7
 plotvalue dm_scoredigits 6 statDexterityBonus 2 138 8

 rem ** Plot three criminal sprites on-screen, left side
 if RandEnemies>$00 then plotbanner dm_criminal4 6 RandEvent 138
 if RandEnemies>$01 then plotbanner dm_criminal4 4 RandEnemies 148
 if RandEnemies>$02 then plotbanner dm_criminal4 1 RandEnemies 128
 if RandEnemies>$03 then plotbanner dm_criminal4 2 RandEnemies 133
 if RandEnemies>$04 then plotbanner dm_criminal4 3 RandEnemies 153

 rem ** Plot your character sprite on-screen, right side 
 plotbanner dm_hero2 7 heroMove 138

 rem ** Debounce the fire button. (joy0fire1)
 gosub JoystickLeftButton
 gosub JoystickRightButton4

 rem ** Based on random number, and if you have enough stamina and knives, you may not be able to run away from a fight.
 if escapeRand>3 && Stamina>$00 && ownKnives>$00 then escapeFlag=1
 rem ** If your stamina or knives drops to 0, reset the flag and allow escape.
 if escapeFlag=1 && Stamina<$01 then escapeFlag=0
 if escapeFlag=1 && ownKnives<$01 then escapeFlag=0
 if FightingFlag=82 then escapeFlag=0

 rem ** Check for Button Presses
 rem ** ------------------------
 rem ** Left Fire 
 rem **  If you're in the middle of a fight and try to exit, there is a chance you will be blocked and must finish the fight.
 rem **  If a fight is finished and an entire gang is defeated, the FightingFlag variable is set to 82 and you will always be able to exit.
 rem **
 rem ** The following line allows exit with the left button after you have defeated an entire gang.
 if debounce=1 && FightingFlag=82 then menubarx=92:menubary=200: gosub sfxoptionselect:gosub AddBonusItems:debounce=0:flagAttacked=0:return: rem ** Exit Fighting Screen when you press the left button
 rem ** The next section first checks if you're allowed to exit the fight based on a random number.
 rem ** If the escape flag is on, you must continue to fight until you are out of stamina or knives or health.
 if escapeFlag=1 then plotchars 'No Escape!' 7 84 25:goto skipAttackExit
 if debounce=1 then menubarx=92:menubary=200:gosub sfxoptionselect:debounce=0:flagAttacked=0:return:rem ** Exit Fighting Screen when you press the left button
skipAttackExit
 
 rem ** Right Fire will continue the fight if you're able
 if FightingFlag=82 then drawscreen:goto screenAttackedLoop:                               rem ** Fight is over, you must exit screen and come back to restart another fight
 if debounce=4 then gosub sfxmovesound:debounce=5:flagAttacked=1:gosub AttackRandomization:rem ** Initiate fight with right button

 rem ** Stat Checks and Modifiers
 rem ** -------------------------
 rem ** Chances of hitting enemies increases with higher dexterity
 rem ** You will die if your health goes to 0, and are redirected to game over/stats screen
 rem ** You cannot fight if your Stamina is 0
 rem ** You cannot fight if your knives is 0
 if Stamina<$01 then plotchars 'Stamina gone' 7 0 25:goto SkipFighting
 if ownKnives<$01 then plotchars 'You have 0 knives' 7 0 25:goto SkipFighting
 if Health<$01 then Death=2:gosub screenStats 
 rem ** Dexterity Modifier increases your chances of an enemy hit as you get closer to the max value of 99.
 gosub DexterityModifier

 rem ** Fight Over
 rem ** ----------
 rem ** The fight is over when all criminals have been killed.
 rem ** You can run anytime, but must kill the entire group to get the dexterity and cash bonus.
 if RandEnemies>$00 then goto FightingSkip
   FightingFlag=82:DisplayFlag=82
     if Dexterity<$99 then dec Dexterity=Dexterity+1
     tempQty=$01
        rem below is the cash bonus for winning a fight
        rem | temp1=minimum | temp2=maximum |
        rem output is tempScorezLo
        tempPriceHi=$00
        temp1=50:temp2=99:gosub setRandomPrice
        tempPriceMed=tempscorezLo
        temp1=23:temp2=99:gosub setRandomPrice  
        tempPriceLo=tempscorezLo
        gosub SellQuantity
      rem      tempPriceHi=$00:tempPriceMed=$74:tempPriceLo=$00:gosub SellQuantity
     dec statCriminalsKilled=statCriminalsKilled+1
     drawscreen
     goto screenAttackedLoop
FightingSkip

 rem ** Assign random fighting event when right button is pressed
 if debounce=0 then goto skipAssignment:rem YOU  THEM
 if RandomEvent=0 then FightingFlag=1:  rem MISS HIT
 if RandomEvent=1 then FightingFlag=2:  rem MISS MISS
 if RandomEvent=2 then FightingFlag=3:  rem MISS HIT 
 if RandomEvent=3 then FightingFlag=4:  rem HIT  HIT 
 if RandomEvent=4 then FightingFlag=5:  rem MISS MISS
 if RandomEvent=5 then FightingFlag=6:  rem MISS MISS
 if RandEvent<3 && FightingFlag=6 then ExtraEnemyFlag=1:rem additional enemies join the fight
 if RandomEvent=6 then FightingFlag=7:  rem HIT  MISS 
 if RandomEvent=7 then FightingFlag=7:  rem MISS MISS 
skipAssignment
 if DisplayFlag=0 then goto skipDisplay

  if DisplayFlag<>1 then goto F1 
  rem       MISS (Lose Knife)             HIT (Enemy Killed)
  plotchars 'MISS' 7 0 11:                plotchars 'HIT' 6 84 11
  plotchars 'Nice Parry!' 6 0 12:         plotchars 'Amazing Takedown!' 6 84 12
  plotchars 'Knife broken!' 5 0 13
F1
  if DisplayFlag<>2 then goto F2
  rem       MISS                          MISS
  plotchars 'MISS' 7 0 11:                plotchars 'MISS' 7 84 11
  plotchars 'Swing and a miss!' 4 0 12:   plotchars 'No Damage' 4 84 12
F2

  if DisplayFlag<>3 then goto F3 
  rem       MISS                          HIT (Enemy Killed)
  plotchars 'MISS' 7 0 11:                plotchars 'HIT' 6 84 11
  plotchars 'Pathetic!' 4 0 12:           plotchars 'Huge Hit!' 6 84 12
F3

  if DisplayFlag<>4 then goto F4
  rem       HIT (Lose Knife)              HIT (Enemy Killed)
  plotchars 'HIT You Lose 1 HP' 6 0 11:   plotchars 'HIT' 6 84 11
  plotchars 'Knife Dropped!' 6 0 12:      plotchars 'Massive Blow!' 6 84 12
F4

  if DisplayFlag<>5 then goto F5
  rem       MISS                          MISS 
  plotchars 'MISS' 7 0 11:                plotchars 'MISS' 7 84 11
  plotchars 'No chance!' 4 0 12:          plotchars 'Close but no cigar!' 4 84 12
F5

  if DisplayFlag<>6 then goto F6
  rem       MISS                          MISS 
  plotchars 'MISS' 7 0 11:                plotchars 'MISS' 7 84 11
  plotchars 'Denied!' 4 0 12:             plotchars 'No Damage' 4 84 12
  if ExtraEnemyFlag=1 then                plotchars 'More enemies have' 5 84 16:plotchars 'joined!' 5 84 18 
F6

  if DisplayFlag<>7 then goto F7 
  rem       HIT                           MISS
  plotchars 'HIT You Lose 1 HP' 6 0 11:   plotchars 'MISS' 7 84 11
  plotchars 'Stabbed!' 6 0 12:            plotchars 'No Damage' 4 84 12
F7

skipDisplay

 if flagAttacked=0 then goto SkipFighting

 rem **      Fight Results
 rem ** ---------------------------------------
 rem ** You        | Criminals
 rem ** ---------- | --------------------------
 rem ** Missed     | Hit
 rem ** -1 Stamina |
 rem ** -1 Knife   |
 rem ** ---------- | --------------------------
 rem 
 if FightingFlag<>1 then goto SkipFight1
    dec Stamina=Stamina-1
    dec ownKnives=ownKnives-1
    dec RandEnemies=RandEnemies-1
    FightingFlag=9
    DisplayFlag=1
    gosub sfxhit
SkipFight1

 rem **      Fight Results
 rem ** ---------------------------------------
 rem ** You        | Criminals
 rem ** ---------- | --------------------------
 rem ** Missed     | Missed
 rem ** -1 Stamina |
 rem ** ---------- | --------------------------
 rem 
 if FightingFlag<>2 then goto SkipFight2
    dec Stamina=Stamina-1
    FightingFlag=9
    DisplayFlag=2
SkipFight2

 rem **      Fight Results
 rem ** ---------------------------------------
 rem ** You        | Criminals
 rem ** ---------- | --------------------------
 rem ** Missed     | Hit 
 rem ** -1 Stamina | -1 Criminal (1 Hit, 1 Kill)
 rem ** ---------- | --------------------------
 rem
 if FightingFlag<>3 then goto SkipFight3
    dec Stamina=Stamina-1
    dec RandEnemies=RandEnemies-1
    FightingFlag=9
    DisplayFlag=3
    gosub sfxhit 
SkipFight3

 rem **      Fight Results
 rem ** ----------------------------------------
 rem ** You        | Criminals
 rem ** ---------- | ---------------------------
 rem ** Hit        | Hit 
 rem ** -1 HP      | -1 Criminal (1 Hit, 1 Kill)
 rem ** -1 Stamina |
 rem ** -1 Knife   |
 rem ** ---------- | --------------------------
 rem
 if FightingFlag<>4 then goto SkipFight4
    dec Stamina=Stamina-1
    dec Health=Health-1
    dec ownKnives=ownKnives-1
    dec RandEnemies=RandEnemies-1
    FightingFlag=9
    DisplayFlag=4
    gosub sfxhit
SkipFight4

 rem **      Fight Results
 rem ** ----------------------------------------
 rem ** You        | Criminals
 rem ** ---------- | ---------------------------
 rem ** Missed     | Missed 
 rem ** -1 Stamina |  
 rem ** ---------- | ---------------------------
 rem 
 if FightingFlag<>5 then goto SkipFight5
    dec Stamina=Stamina-1
    FightingFlag=9
    DisplayFlag=5
SkipFight5

 rem **      Fight Results
 rem ** ---------------------------------------
 rem ** You        | Criminals
 rem ** ---------- | --------------------------
 rem ** Missed     | Missed
 rem ** -1 Stamina |
 rem ** ---------- | --------------------------
 rem 
 if FightingFlag<>6 then goto SkipFight6
    dec Stamina=Stamina-1
    FightingFlag=9
    DisplayFlag=6
    if ExtraEnemyFlag=1 then ExtraEnemyFlag=0:dec RandEnemies=RandEnemies+2:drawscreen
SkipFight6

 rem **     Fight Results
 rem ** ---------------------------------------
 rem ** You        | Criminals
 rem ** ---------- | --------------------------
 rem ** Hit        | Missed  
 rem ** -1 HP      |
 rem ** -1 Stamina |
 rem ** ---------- | --------------------------
 rem 
 if FightingFlag<>7 then goto SkipFight7
    DisplayFlag=7
    dec Health=Health-1
    dec Stamina=Stamina-1
    FightingFlag=9
SkipFight7

SkipFighting 
 if FightingFlag=9 then flagAttacked=0
 drawscreen

 goto screenAttackedLoop

DexterityModifier
 if Dexterity>30 && Dexterity<61 then DexLevel=1
 if Dexterity>60 && Dexterity<91 then DexLevel=2
 if Dexterity>90 && Dexterity<96 then DexLevel=3
 if Dexterity>95 then DexLevel=4
 return

AddBonusItems
 if Dexterity<95 then dec statDexterityBonus=statDexterityBonus+1
 if ownKnives<95 then dec ownKnives=ownKnives+5
 return

  rem ********************************************************
  rem **************** Buy Screen Subroutine *****************
  rem ********************************************************

screenBuy
 
 rem ** Reset Menu Selector, joystick debounce, and Flags 
 menubarx=80:     menubary=120:     debounce=0
 flagBuy=0:       flagEvent=0

 rem ** Reset Selections
 gosub resetSelect

 rem ** Reset Buy Quantities
 buyMatches=0:    buyFirstAid=0:    buyShovel=0
 buyRope=0:       buyCompass=0:     buyGPS=0
 buyFlare=0:      buyFuse=0:        buyClothes=0
 buyCanteen=0:    buyTobacco=0     
 
 rem ** Reset Purchase Variables
 tempQty=$00:      tempPriceLo=$00:    tempPriceMed=$00
 tempPriceHi=$00

 gosub menuClearSelections

screenBuyLoop
 
 drawwait
 clearscreen

 if backpackFree=$00 then gosub buyDenied

 rem ** Debounce the fire button. DEBUG
 gosub JoystickLeftButton
 gosub JoystickRightButton4
 if debounce=1 then gosub sfxmovesound:debounce=0:menuPos=1:menubarx=8:menubary=192:return 

 gosub checkBackpackFree ; backpackFree = Total Backpack Space - Used Backpack Space

 rem ** Plot prices, quantities, and stat values 
 gosub plotValues

 rem ** Plot the menu selection sprite 
 plotsprite dm_menuicon 6 menubarx menubary

 plotchars 'Max' 2 134 15
 plotvalue dm_scoredigits 2 tempQty 2 148 15

 rem ** Plot on-screen text 
 gosub plotCommonScreenText
 gosub plotCityName
 gosub plotBuySellText

 rem ** Joystick movement
 gosub JoystickMoveUpDebounce
 gosub JoystickMoveDownDebounce

 rem ** Move selection up/down
 if JoyMoveUpDebounce=1 then JoyMoveUpDebounce=0: gosub sfxmenubuysellmove:menubary=menubary-8
 if JoyMoveDownDebounce=1 then JoyMoveDownDebounce=0: gosub sfxmenubuysellmove:menubary=menubary+8

 rem ** Clear Quantity if you move up or down, except for up on the top and down when at the bottom
 if menubary=200 && JoyMoveUpDebounce=1 then goto skipClearQuantities
 if menubary=120 && JoyMoveDownDebounce=1 then goto skipClearQuantities
 if JoyMoveUpDebounce=1 || JoyMoveDownDebounce=1 then clearQuantities
skipClearQuantities

 rem ** Prevent scrolling off the top or bottom of the menu
 if menubary>200 then menubary=200
 if menubary<120 then menubary=120
 
 rem ** Purchase Items
 rem ** --------------
 rem ** Select Quantity of Items to Buy 
 rem ** Check menu position, then add or subtract the value of the item you want to buy 
 
 rem ** Matches
 rem ** -------
 if menubary=120 && selectMatches=0 then menuPos=1:gosub menuSelectionMatches:tempPriceMed=priceMatchesMed:tempPriceLo=priceMatchesLo:gosub checkMaximumQuantity
 if selectMatches<>1 then goto skipProcessMatches
     plotvalue dm_scoredigits 7 buyMatches 2 84 15
      
      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$79 then tempQty=$80                                     ;Limit Purchase Quantity

      if buyMatches>backpackFree || buyMatches>tempQty then dec buyMatches=buyMatches-1:gosub buyStopped2:goto skipProcessMatches
     if joy0left && buyMatches>0 then gosub sfxoptionselect:dec buyMatches=buyMatches-1
     if joy0right && buyMatches<tempQty+backpackFree then gosub sfxoptionselect:dec buyMatches=buyMatches+1
     if buyMatches=0 then goto skipProcessMatches
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyMatches:goto completeBuyMatches:debounce=0
skipProcessMatches

 rem ** FirstAid
 rem ** --------
 if menubary=128 && selectFirstAid=0 then menuPos=1:gosub menuSelectionFirstAid:tempPriceMed=priceFirstAidMed:tempPriceLo=priceFirstAidLo:gosub checkMaximumQuantity
 if selectFirstAid<>1 then goto skipProcessFirstAid
     plotvalue dm_scoredigits 7 buyFirstAid 2 84 16

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$34 then tempQty=$35                                     ;Limit Purchase Quantity

     if buyFirstAid>backpackFree || buyFirstAid>tempQty then dec buyFirstAid=buyFirstAid-1:gosub buyStopped2:goto skipProcessFirstAid     
     if joy0left && buyFirstAid>0 then gosub sfxoptionselect:dec buyFirstAid=buyFirstAid-1
     if joy0right && buyFirstAid<tempQty+backpackFree then gosub sfxoptionselect:dec buyFirstAid=buyFirstAid+1
skipCheck2
     if buyFirstAid=0 then goto skipProcessFirstAid
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyFirstAid:goto completeBuyFirstAid:debounce=0
skipProcessFirstAid

 rem ** Shovel 
 rem ** ------
 if menubary=136 && selectShovel=0 then menuPos=1:gosub menuSelectionShovel:tempPriceMed=priceShovelMed:tempPriceLo=priceShovelLo:gosub checkMaximumQuantity
 if selectShovel<>1 then goto skipProcessShovel
     plotvalue dm_scoredigits 7 buyShovel 2 84 17

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                   ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$39 then tempQty=$40                                      ;Limit Purchase Quantity

     if buyShovel>backpackFree || buyShovel>tempQty then dec buyShovel=buyShovel-1:gosub buyStopped2:goto skipProcessShovel   
     if joy0left && buyShovel>0 then gosub sfxoptionselect:dec buyShovel=buyShovel-1
     if joy0right && buyShovel<tempQty+backpackFree then gosub sfxoptionselect:dec buyShovel=buyShovel+1
skipCheck3
     if buyShovel=0 then goto skipProcessShovel
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyShovel:goto completeBuyShovel:debounce=0
skipProcessShovel

 rem ** Rope 
 rem ** ----
 if menubary=144 && selectRope=0 then menuPos=1:gosub menuSelectionRope:tempPriceMed=priceRopeMed:tempPriceLo=priceRopeLo:gosub checkMaximumQuantity
 if selectRope<>1 then goto skipProcessRope
     plotvalue dm_scoredigits 7 buyRope 2 84 18

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$09 then tempQty=$10                                     ;Limit Purchase Quantity

     if buyRope>backpackFree || buyRope>tempQty then dec buyRope=buyRope-1:gosub buyStopped2:goto skipProcessRope   
     if joy0left && buyRope>0 then gosub sfxoptionselect:dec buyRope=buyRope-1
     if joy0right && buyRope<tempQty+backpackFree then gosub sfxoptionselect:dec buyRope=buyRope+1
skipCheck4
     if buyRope=0 then goto skipProcessRope
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyRope:goto completeBuyRope:debounce=0
skipProcessRope

 rem ** Compass
 rem ** -------
 if menubary=152 && selectCompass=0 then menuPos=1:gosub menuSelectionCompass:tempPriceMed=priceCompassMed:tempPriceLo=priceCompassLo:gosub checkMaximumQuantity
 if selectCompass<>1 then goto skipProcessCompass
     plotvalue dm_scoredigits 7 buyCompass 2 84 19

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$64 then tempQty=$65                                     ;Limit Purchase Quantity

     if buyCompass>backpackFree || buyCompass>tempQty then dec buyCompass=buyCompass-1:gosub buyStopped2:goto skipProcessCompass   
     if joy0left && buyCompass>0 then gosub sfxoptionselect:dec buyCompass=buyCompass-1
     if joy0right && buyCompass<tempQty+backpackFree then gosub sfxoptionselect:dec buyCompass=buyCompass+1
skipCheck5
     if buyCompass=0 then goto skipProcessCompass
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyCompass:goto completeBuyCompass:debounce=0
skipProcessCompass
 
 rem ** GPS
 rem ** ---
 if menubary=160 && selectGPS=0 then menuPos=1:gosub menuSelectionGPS:tempPriceMed=priceGPSMed:tempPriceLo=priceGPSLo:gosub checkMaximumQuantity
 if selectGPS<>1 then goto skipProcessGPS
     plotvalue dm_scoredigits 7 buyGPS 2 84 20

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$14 then tempQty=$15                                     ;Limit Purchase Quantity

      rem tempSpaceCheck=scoreTotalBackpackSpaceLo-1
      rem if tempQty>backpackFree then tempQty=tempQty-1
      rem if scoreUsedBackpackSpaceLo>tempSpaceCheck then scoreUsedBackpackSpaceLo=scoreTotalBackpackSpaceLo:gosub buyStopped2:goto skipProcessGPS

      if buyGPS>backpackFree || buyGPS>tempQty then dec buyGPS=buyGPS-1:gosub buyStopped2:goto skipProcessGPS   
     if joy0left && buyGPS>0 then gosub sfxoptionselect:dec buyGPS=buyGPS-1
     if joy0right && buyGPS<tempQty+backpackFree then gosub sfxoptionselect:dec buyGPS=buyGPS+1
skipCheck6
     if buyGPS=0 then goto skipProcessGPS
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyGPS:goto completeBuyGPS:debounce=0
skipProcessGPS

 rem ** Flare 
 rem ** -----
 if menubary=168 && selectFlare=0 then menuPos=1:gosub menuSelectionFlare:tempPriceMed=priceFlareMed:tempPriceLo=priceFlareLo:gosub checkMaximumQuantity
 if selectFlare<>1 then goto skipProcessFlare
     plotvalue dm_scoredigits 7 buyFlare 2 84 21

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$54 then tempQty=$55                                     ;Limit Purchase Quantity

     if buyFlare>backpackFree || buyFlare>tempQty then dec buyFlare=buyFlare-1:gosub buyStopped2:goto skipProcessFlare   
     if joy0left && buyFlare>$00 then gosub sfxoptionselect:dec buyFlare=buyFlare-$01
     if joy0right && buyFlare<tempQty+backpackFree then gosub sfxoptionselect:dec buyFlare=buyFlare+$01
skipCheck7
     if buyFlare=0 then goto skipProcessFlare
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyFlare:goto completeBuyFlare:debounce=0
skipProcessFlare

 rem ** Fuse 
 rem ** ----
 if menubary=176 && selectFuse=0 then menuPos=1:gosub menuSelectionFuse:tempPriceMed=priceFuseMed:tempPriceLo=priceFuseLo:gosub checkMaximumQuantity
 if selectFuse<>1 then goto skipProcessFuse
     plotvalue dm_scoredigits 7 buyFuse 2 84 22

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$34 then tempQty=$35                                     ;Limit Purchase Quantity

     if buyFuse>backpackFree || buyFuse>tempQty then dec buyFuse=buyFuse-1:gosub buyStopped2:goto skipProcessFuse   
     if joy0left && buyFuse>0 then gosub sfxoptionselect:dec buyFuse=buyFuse-1
     if joy0right && buyFuse<tempQty+backpackFree then gosub sfxoptionselect:dec buyFuse=buyFuse+1
skipCheck8
     if buyFuse=0 then goto skipProcessFuse
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyFuse:goto completeBuyFuse:debounce=0
skipProcessFuse

 rem ** Clothes
 rem ** -------
 if menubary=184 && selectClothes=0 then menuPos=1:gosub menuSelectionClothes:tempPriceMed=priceClothesMed:tempPriceLo=priceClothesLo:gosub checkMaximumQuantity
 if selectClothes<>1 then goto skipProcessClothes
     plotvalue dm_scoredigits 7 buyClothes 2 84 23

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$49 then tempQty=$50                                     ;Limit Purchase Quantity

     if buyClothes>backpackFree || buyClothes>tempQty then dec buyClothes=buyClothes-1:gosub buyStopped2:goto skipProcessClothes   
     if joy0left && buyClothes>0 then gosub sfxoptionselect:dec buyClothes=buyClothes-1
     if joy0right && buyClothes<tempQty+backpackFree then gosub sfxoptionselect:dec buyClothes=buyClothes+1
skipCheck9
     if buyClothes=0 then goto skipProcessClothes
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyClothes:goto completeBuyClothes:debounce=0
skipProcessClothes

 rem ** Canteen
 rem ** -------
 if menubary=192 && selectCanteen=0 then menuPos=1:gosub menuSelectionCanteen:tempPriceMed=priceCanteenMed:tempPriceLo=priceCanteenLo:gosub checkMaximumQuantity
 if selectCanteen<>1 then goto skipProcessCanteen
     plotvalue dm_scoredigits 7 buyCanteen 2 84 24

      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$84 then tempQty=$85                                     ;Limit Purchase Quantity

     if buyCanteen>backpackFree || buyCanteen>tempQty then dec buyCanteen=buyCanteen-1:gosub buyStopped2:goto skipProcessCanteen   
     if joy0left && buyCanteen>0 then gosub sfxoptionselect:dec buyCanteen=buyCanteen-1
     if joy0right && buyCanteen<tempQty+backpackFree then gosub sfxoptionselect:dec buyCanteen=buyCanteen+1
skipCheck10
     if buyCanteen=0 then goto skipProcessCanteen
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyCanteen:goto completeBuyCanteen:debounce=0
skipProcessCanteen

 rem ** Tobacco
 rem ** -------
 if menubary=200 && selectTobacco=0 then menuPos=1:gosub menuSelectionTobacco:tempPriceMed=priceTobaccoMed:tempPriceLo=priceTobaccoLo:gosub checkMaximumQuantity
 if selectTobacco<>1 then goto skipProcessTobacco
     plotvalue dm_scoredigits 7 buyTobacco 2 84 25
                                                        
      rem tmpQty is the highest number of items you can buy.  Verify it against free backpack space and quantity limits as well here.
      rem 
      if tempQty>=backpackFree then tempQty=backpackFree                  ;If the max amount you can buy is more than your free space, set the max to free space
      if tempQty>$79 then tempQty=$80                                     ;Limit Purchase Quantity

     if buyTobacco>backpackFree || buyTobacco>tempQty then dec buyTobacco=buyTobacco-1:gosub buyStopped2:goto skipProcessTobacco   
     if joy0left && buyTobacco>0 then gosub sfxoptionselect:dec buyTobacco=buyTobacco-1
     if joy0right && buyTobacco<tempQty+backpackFree then gosub sfxoptionselect:dec buyTobacco=buyTobacco+1
skipCheck11
     if buyTobacco=0 then goto skipProcessTobacco
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=192:gosub menuClearSelections:tempQty=buyTobacco:goto completeBuyTobacco:debounce=0
skipProcessTobacco

 drawscreen
 goto screenBuyLoop

plotBuySellText
 gosub plottopLeftLine
 plotchars 'Select item' 4 0 15:           plotchars 'Matches' 0 94 15
                                           plotchars 'First Aid' 0 94 16
                                           plotchars 'Shovel' 0 94 17
                                           plotchars 'Rope' 0 94 18
                                           plotchars 'Compass' 0 94 19
                                           plotchars 'GPS' 0 94 20
                                           plotchars 'Flare' 0 94 21
  plotchars 'L/R for Quantity' 4 0 22:     plotchars 'Fuse' 0 94 22
                                           plotchars 'Clothes' 0 94 23
  plotchars 'Left Fire Exits'     4 0 24:  plotchars 'Canteen' 0 94 24
  plotchars 'Right Fire Confirms' 4 0 25:  plotchars 'Tobacco' 0 94 25
  gosub plotBottomLine27
 return 

  rem ********************************************************
  rem **************** Sell Screen Subroutine ****************
  rem ********************************************************

screenSell

 gosub resetSellVariables
 gosub menuClearSelections

screenSellLoop
 drawwait
 clearscreen
  
 rem ** Reduce sell prices on expensive items
 rem  Rope

 rem ** Plot prices, quantities, and stat values 
 gosub plotValues

 rem ** Plot the menu selection sprite 
 plotsprite dm_menuicon 6 menubarx menubary

 rem ** Plot text on the screen 
 gosub plotCommonScreenText
 gosub plotCityName
 gosub plotBuySellText 

 rem ** Joystick Movement
 gosub JoystickMoveUpDebounce
 gosub JoystickMoveDownDebounce
 if JoyMoveUpDebounce=1 then JoyMoveUpDebounce=0: gosub clearQuantities:gosub sfxoptionselect:menubary=menubary-8
 if JoyMoveDownDebounce=1 then JoyMoveDownDebounce=0:gosub clearQuantities:gosub sfxoptionselect:menubary=menubary+8

 rem **debounce the fire button. It's activated when you release the button, not when you press it.
 gosub JoystickLeftButton 
 gosub JoystickRightButton4
 if debounce=1 then gosub sfxmovesound:debounce=0:menuPos=6:menubarx=8:menubary=200:return 

 rem **Prevent scrolling off the top or bottom of the menu
 if menubary>200 then menubary=200
 if menubary<120 then menubary=120
 
 rem ** Sell Items
 rem ** ----------
 rem ** Select Quantity of Items to Sell 
 rem ** Check menu position, then add or subtract the value of the item you want to sell 

 rem ** Matches  
 rem ** -------                                      
 if menubary=120 && selectMatches=0 then menuPos=1:gosub menuSelectionMatches:tempPriceMed=priceMatchesMed:tempPriceLo=priceMatchesLo
 if selectMatches<>1 then goto skipProcessMatches2
     plotvalue dm_scoredigits 7 sellMatches 2 84 15
     if joy0left && sellMatches>0 then gosub sfxoptionselect:dec sellMatches=sellMatches-1
     if joy0right && sellMatches<ownMatches then gosub sfxoptionselect:dec sellMatches=sellMatches+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellMatches:goto completeSellMatches:debounce=0
skipProcessMatches2

 rem ** FirstAid
 rem ** --------
 if menubary=128 && selectFirstAid=0 then menuPos=1:gosub menuSelectionFirstAid:tempPriceMed=priceFirstAidMed:tempPriceLo=priceFirstAidLo
 if selectFirstAid<>1 then goto skipProcessFirstAid2
     plotvalue dm_scoredigits 7 sellFirstAid 2 84 16
     if joy0left && sellFirstAid>0 then gosub sfxoptionselect:dec sellFirstAid=sellFirstAid-1
     if joy0right && sellFirstAid<ownFirstAid then gosub sfxoptionselect:dec sellFirstAid=sellFirstAid+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellFirstAid:goto completeSellFirstAid:debounce=0
skipProcessFirstAid2

 rem ** Shovel 
 rem ** ------
 if menubary=136 && selectShovel=0 then menuPos=1:gosub menuSelectionShovel:tempPriceMed=priceShovelMed:tempPriceLo=priceShovelLo
 if selectShovel<>1 then goto skipProcessShovel2
     plotvalue dm_scoredigits 7 sellShovel 2 84 17
     if joy0left && sellShovel>0 then gosub sfxoptionselect:dec sellShovel=sellShovel-1
     if joy0right && sellShovel<ownShovel then gosub sfxoptionselect:dec sellShovel=sellShovel+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellShovel:goto completeSellShovel:debounce=0
skipProcessShovel2

 rem ** Rope 
 rem ** ----
 if menubary=144 && selectRope=0 then menuPos=1:gosub menuSelectionRope:tempPriceMed=priceRopeMed:tempPriceLo=priceRopeLo
 if selectRope<>1 then goto skipProcessRope2
     plotvalue dm_scoredigits 7 sellRope 2 84 18
     if joy0left && sellRope>0 then gosub sfxoptionselect:dec sellRope=sellRope-1
     if joy0right && sellRope<ownRope then gosub sfxoptionselect:dec sellRope=sellRope+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellRope:goto completeSellRope:debounce=0
skipProcessRope2

 rem ** Compass
 rem ** -------
 if menubary=152 && selectCompass=0 then menuPos=1:gosub menuSelectionCompass:tempPriceMed=priceCompassMed:tempPriceLo=priceCompassLo
 if selectCompass<>1 then goto skipProcessCompass2
     plotvalue dm_scoredigits 7 sellCompass 2 84 19
     if joy0left && sellCompass>0 then gosub sfxoptionselect:dec sellCompass=sellCompass-1
     if joy0right && sellCompass<ownCompass then gosub sfxoptionselect:dec sellCompass=sellCompass+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellCompass:goto completeSellCompass:debounce=0
skipProcessCompass2
 
 rem ** GPS
 rem ** ---
 if menubary=160 && selectGPS=0 then menuPos=1:gosub menuSelectionGPS:tempPriceMed=priceGPSMed:tempPriceLo=priceGPSLo
 if selectGPS<>1 then goto skipProcessGPS2
     plotvalue dm_scoredigits 7 sellGPS 2 84 20
     if joy0left && sellGPS>0 then gosub sfxoptionselect:dec sellGPS=sellGPS-1
     if joy0right && sellGPS<ownGPS then gosub sfxoptionselect:dec sellGPS=sellGPS+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellGPS:goto completeSellGPS:debounce=0
skipProcessGPS2

 rem ** Flare 
 rem ** -----
 if menubary=168 && selectFlare=0 then menuPos=1:gosub menuSelectionFlare:tempPriceMed=priceFlareMed:tempPriceLo=priceFlareLo
 if selectFlare<>1 then goto skipProcessFlare2
     plotvalue dm_scoredigits 7 sellFlare 2 84 21
     if joy0left && sellFlare>0 then gosub sfxoptionselect:dec sellFlare=sellFlare-1
     if joy0right && sellFlare<ownFlare then gosub sfxoptionselect:dec sellFlare=sellFlare+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellFlare:goto completeSellFlare:debounce=0
skipProcessFlare2

 rem ** Fuse 
 rem ** ----
 if menubary=176 && selectFuse=0 then menuPos=1:gosub menuSelectionFuse:tempPriceMed=priceFuseMed:tempPriceLo=priceFuseLo
 if selectFuse<>1 then goto skipProcessFuse2
     plotvalue dm_scoredigits 7 sellFuse 2 84 22
     if joy0left && sellFuse>0 then gosub sfxoptionselect:dec sellFuse=sellFuse-1
     if joy0right && sellFuse<ownFuse then gosub sfxoptionselect:dec sellFuse=sellFuse+1
     if debounce=4 then gosub sfxoptionselect:  menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellFuse:goto completeSellFuse:debounce=0
skipProcessFuse2

 rem ** Clothes
 rem ** -------
 if menubary=184 && selectClothes=0 then menuPos=1:gosub menuSelectionClothes:tempPriceMed=priceClothesMed:tempPriceLo=priceClothesLo
 if selectClothes<>1 then goto skipProcessClothes2
     plotvalue dm_scoredigits 7 sellClothes 2 84 23
     if joy0left && sellClothes>0 then gosub sfxoptionselect:dec sellClothes=sellClothes-1
     if joy0right && sellClothes<ownClothes then gosub sfxoptionselect:dec sellClothes=sellClothes+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellClothes:goto completeSellClothes:debounce=0
skipProcessClothes2

 rem ** Canteen
 rem ** -------
 if menubary=192 && selectCanteen=0 then menuPos=1:gosub menuSelectionCanteen:tempPriceMed=priceCanteenMed:tempPriceLo=priceCanteenLo
 if selectCanteen<>1 then goto skipProcessCanteen2
     plotvalue dm_scoredigits 7 sellCanteen 2 84 24
     if joy0left && sellCanteen>0 then gosub sfxoptionselect:dec sellCanteen=sellCanteen-1
     if joy0right && sellCanteen<ownCanteen then gosub sfxoptionselect:dec sellCanteen=sellCanteen+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellCanteen:goto completeSellCanteen:debounce=0
skipProcessCanteen2

 rem ** Tobacco
 rem ** -------
 if menubary=200 && selectTobacco=0 then menuPos=1:gosub menuSelectionTobacco:tempPriceMed=priceTobaccoMed:tempPriceLo=priceTobaccoLo
 if selectTobacco<>1 then goto skipProcessTobacco2
     plotvalue dm_scoredigits 7 sellTobacco 2 84 25
     if joy0left && sellTobacco>0 then gosub sfxoptionselect:dec sellTobacco=sellTobacco-1
     if joy0right && sellTobacco<ownTobacco then gosub sfxoptionselect:dec sellTobacco=sellTobacco+1
     if debounce=4 then gosub sfxoptionselect: menuPos=1:menubarx=8:menubary=200:gosub menuClearSelections:tempQty=sellTobacco:goto completeSellTobacco:debounce=0
skipProcessTobacco2

 drawscreen
 goto screenSellLoop

plotCommonScreenText
 rem ** Main Screen Text
 rem ** ----------------
 rem ** On the main screen and buy/sell screens the top portion of the screen does not change.
 rem ** This is called by each of those subroutines to plot the text.

 gosub plotTopLine0
 plotchars '   Days Remaining' 0 0 1  :plotchars 'Item       Cost  Own' 0 80 1     
 plotchars '((((((((()))))))))' 0 0 2  :plotchars '(((((((((())))))))))' 0 80 2
 plotchars 'Credits   $' 3 3 3        :plotchars 'Matches   $' 7 86 3
 plotchars 'Bank      $' 3 3 4        :plotchars 'First Aid $' 7 86 4
 plotchars 'Debt      $' 3 3 5        :plotchars 'Shovel    $' 7 86 5
 rem plotchars '%===%===%======%' 1 3 6
 plotchars '(((((((())))))))' 1 3 6
 plotchars 'Knives      /99' 0 5 7  :plotchars 'Rope      $' 7 86 6
 plotchars 'Health      /99' 0 5 8  :plotchars 'Compass   $' 7 86 7
 plotchars 'Backpack    /  ' 0 5 9  :plotchars 'GPS       $' 7 86 8
 plotchars 'Food        /99' 0 5 10 :plotchars 'Flare     $' 7 86 9
 plotchars 'Stamina     /99' 0 5 11 :plotchars 'Fuse      $' 7 86 10
 plotchars 'Charisma    /99' 0 5 12 :plotchars 'Clothes   $' 7 86 11
 plotchars 'Dexterity   /99' 0 5 13 :plotchars 'Canteen   $' 7 86 12
                                     plotchars 'Tobacco   $' 7 86 13

  gosub plotItemIcons

 return 

plotTravelMap
 rem ** Plot Travel Map Text and Image (used twice)
 plotbanner dm_map2 0 0 88

 rem ** Travel Map Text
 rem ** ---------------
 rem ** Plot City names next to the travel map 
 rem New Vegas, Lost Angeles, New Salem, Concord, Diamond City, Bedford Falls
 rem box pattern
 rem    -***************************-
 rem    #                           #
 rem    \;;;;;;;;;;;;;;;;;;;;;;;;;;;\
 rem 

 ;plotchars '[######]' 0 124 10
 ;plotchars '=======' 1 129 10
 plotchars 'New'     menuColor1 130 11
 plotchars 'Vegas'   menuColor1 129 12
 ;plotchars '=======' 1 129 13
 plotchars 'Lost'    menuColor2 130 14
 plotchars 'Angeles' menuColor2 130 15
 ;plotchars '=======' 1 129 16
 plotchars 'New'     menuColor3 130 17
 plotchars 'Salem'   menuColor3 130 18
 ;plotchars '=======' 1 129 19
 plotchars 'Concord' menuColor4 130 20
 ;plotchars '=======' 1 129 21
 plotchars 'Diamond' menuColor5 130 22
 plotchars 'City'    menuColor5 130 23
 ;plotchars '=======' 1 129 24
 plotchars 'Bedford' menuColor6 130 25
 plotchars 'Falls'   menuColor6 130 26
 return

JoystickRightButton4
 if joy0fire0 then debounce=3
 if !joy0fire0 && debounce=3 then debounce=4
 return

AttackRandomization
 RandEvent=rand&7+10
 RandomEvent=rand&7
 heroMove=(rand&31)+25
 
 rem if RandomEvent=0 then FightingFlag=1:  rem MISS HIT
 rem if RandomEvent=1 then FightingFlag=2:  rem MISS MISS
 rem if RandomEvent=2 then FightingFlag=3:  rem MISS HIT 
 rem if RandomEvent=3 then FightingFlag=4:  rem HIT  HIT 
 rem if RandomEvent=4 then FightingFlag=5:  rem MISS MISS
 rem if RandomEvent=5 then FightingFlag=6:  rem MISS MISS
 rem if RandomEvent=6 then FightingFlag=7:  rem HIT  MISS 
 rem if RandomEvent=7 then FightingFlag=7:  rem MISS MISS 

 if DexLevel=1 && RandomEvent>6 then goto AttackRandomization:     rem ** Enemy Hit Chance is 50%
 if DexLevel=2 && RandomEvent>5 then goto AttackRandomization:     rem ** Enemy Hit Chance is 60%
 if DexLevel=3 && RandomEvent>4 then goto AttackRandomization:     rem ** Enemy Hit Chance is 75%
 if DexLevel<>4 then goto skipDex4
 if RandomEvent>4 && RandomEvent<2 then goto AttackRandomization:  rem ** Enemy Hit Chance is 100%
skipDex4

 FightingFlag=0
 return

CharismaModifier
  rem ** 6/30/22 -  Disabling free items in v1.2
  rem ** Apply Charisma Modifier
  rem ** -----------------------
  rem ** Will randomly give you extra items for free from the Merchant
  rem ** If your Charisma is high enough. :)
  rem if Charisma>$30 && backpackFree>$01 && ownMatches<$99  && CharismaFlag=1 then dec ownMatches=ownMatches+1:   dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+$01
  rem if Charisma>$45 && backpackFree>$01 && ownRope<$99     && CharismaFlag=1 then dec ownRope=ownRope+1:         dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+$01
  rem if Charisma>$60 && backpackFree>$01 && ownTobacco<$99  && CharismaFlag=1 then dec ownTobacco=ownTobacco+1:   dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+$01
  rem if Charisma>$75 && backpackFree>$01 && ownFirstAid<$99 && CharismaFlag=1 then dec ownFirstAid=ownFirstAid+1: dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+$01
  CharismaFlag=2
  return

buyBackpackDenied
   plotchars 'You own it' 6 8 17
   return

plottopLeftLine
   rem X default is 14 for main screen, 10 for travel screen.
   if flagTravelLine=1 then xLine=10 else xLine=14
   plotchars '@@@@@@@@@@@@@@@@@@@' 0 0 xLine: plotchars '@@@@@@@@@@@@@@@@@@@@@' 0 76 xLine
   return

buyDenied
   plotchars 'Backpack' 6 0 18
   plotchars 'is full.' 6 0 19
   return
   
buyStopped
   plotchars 'Inventory depleted' 6 8 17
   return

buyStopped2
   plotchars 'Backpack Full' 0 10 17
   plotchars 'or' 0 29 18
   plotchars 'hit Max Limit' 0 10 19
   return

plotLeftFireButton16
   plotchars 'Press Left Fire' 4 0 16
   return

plotRightFireButton8
   plotchars 'Press Right Fire' 7 0 8
   return 

sfxoptionselect
   playsfx sfx_option_select
   return 

plotExit24
   plotchars 'Left fire exits' 4 0 24
   return

resetTempScoreA
  tempscoreaHi=$00:tempscoreaMed=$00:tempscoreaLo=$00 
  return

resetTempScoreB
  tempscorebHi=$00:tempscorebMed=$00:tempscorebLo=$00 
  return

plotItemIcons
  rem ** Plot item icons on the main screen
  plotsprite dm_icon_matches  5 81 22         ; 27 bytes each
  plotsprite dm_icon_firstaid 6 81 31 
  plotsprite dm_icon_shovel   7 81 40 
  plotsprite dm_icon_rope     3 81 48 
  plotsprite dm_icon_compass  4 81 56 
  plotsprite dm_icon_GPS      5 81 65 
  plotsprite dm_icon_flare    6 81 72 
  plotsprite dm_icon_fuse     7 81 80 
  plotsprite dm_icon_clothes  1 81 88 
  plotsprite dm_icon_canteen  3 81 96 
  plotsprite dm_icon_tobacco  2 81 104
  return

plotTopLine0
  plotchars '\\\\\\\\\\\\\\\\\\\\\' 0 0 0  :plotchars '\\\\\\\\\\\\\\\\\\\\\' 0 76 0
  return

plotBottomLine27
  if flagTravelLine=1 then xLine2=27 else xLine2=26
  plotchars '\;;;;;;;;;;;;;;;;;;' 0 0 xLine2:plotchars ';;;;;;;;;;;;;;;;;;;;\' 0 76 xLine2
  return

resetSellVariables
 menubarx=80:menubary=120
 flagSell=0:flagEvent=0

 rem ** Reset Selections
 gosub resetSelect

 sellMatches=0:   sellFirstAid=0:   sellShovel=0
 sellRope=0:      sellCompass=0:    sellGPS=0
 sellFlare=0:     sellFuse=0:       sellClothes=0
 sellCanteen=0:   sellTobacco=0  
 
 rem ** Reset temp variables
 tempQty=$00:       tempPriceLo=$00:     tempPriceMed=$00
 tempPriceHi=$00

 rem ** Reset joystick debounce
 debounce=0

 return

  rem ***************************************************************
  rem **************** Joystick Debounce Subroutines ****************
  rem ***************************************************************

JoystickLeftButton
 if joy0fire1 then debounce=2
 if !joy0fire1 && debounce=2 then debounce=1
 return
JoystickRightButton
 if joy0fire0 then debounce=2
 if !joy0fire0 && debounce=2 then debounce=1
 return
JoystickMoveUpDebounce 
 if joy0up then JoyMoveUpDebounce=2
 if !joy0up && JoyMoveUpDebounce=2 then JoyMoveUpDebounce=1
 return
JoystickMoveDownDebounce 
 if joy0down then JoyMoveDownDebounce=2
 if !joy0down && JoyMoveDownDebounce=2 then JoyMoveDownDebounce=1
 return
JoystickMoveLeftDebounce 
 if joy0left then JoyMoveLeftDebounce=2
 if !joy0left && JoyMoveLeftDebounce=2 then JoyMoveLeftDebounce=1
 return
JoystickMoveRightDebounce 
 if joy0right then JoyMoveRightDebounce=2
 if !joy0right && JoyMoveRightDebounce=2 then JoyMoveRightDebounce=1
 return

 rem ** Bank Menu Movement
 rem ** ------------------
bankmenudown
 tempscoreaHi=$00:tempscoreaMed=$00:tempscoreaLo=$00
 ;tempscorebHi=scoreBankHi:tempscorebMed=scoreBankMed:tempscorebLo=scoreBankLo
 if menubary=168 then return
 if !joy0down then menubary=168:return
 ;gosub resetTempScoreA 
 goto menumovedown
bankmenuup
 tempscorebHi=$00:tempscorebMed=$00:tempscorebLo=$00
 ;tempscoreaHi=scoreCreditsHi:tempscoreaMed=scoreCreditsMed:tempscoreaLo=scoreCreditsLo
 if menubary=160 then return
 if !joy0up then menubary=160:return
 ;gosub resetTempScoreB
 goto menumoveup

 rem ** Main Menu Movement
 rem ** ------------------
menumoveleft
 if menubarx=120 then menubarx=92:return
 if menubarx=92 then menubarx=60:return
 if menubarx=60 then menubarx=32:return
 if menubarx=32 then menubarx=8:return
 if menubarx=8 then menubarx=8:return
 goto menumoveleft
menumoveright
 if menubarx=8 then menubarx=32:return
 if menubarx=32 then menubarx=60:return
 if menubarx=60 then menubarx=92:return
 if menubarx=92 then menubarx=120:return
 if menubarx=120 then menubarx=120:return
 goto menumoveright

 rem ** End of Day Stat Modifiers
 rem ** -------------------------
FinishTheDay

 rem ** Interest Modifier on Debt
 rem ** -----------------
 rem ** Interest added to Debt every day as long as there is a balance
 rem **   Add $700 per day on Days 1-7
 rem **   Add $1000 per day on Days 8-31
 rem ** Once your Charisma reaches 40 or more, interest is reduced to only $500 a day, at 80 or more, $300 a day.
 rem ** Charisma based interest overrides normal interest - it is used exclusively once you hit 40 or higher.
 if scoreDebtHi=$00 && scoreDebtMed=$00 && scoreDebtLo=$00 then goto skipInterestPayment
   if Charisma>$80 then tempPriceMed=$03:goto skipInt2
   if Charisma>$40 then tempPriceMed=$05:goto skipInt2 
   if daysleft<$08 then tempPriceMed=$07 else tempPriceMed=$10
 tempPriceLo=$00
skipInt2
 gosub AddDebt
skipInterestPayment
 gosub resetFlags
 ;debounce=0

 rem ** Stamina and Food Modifiers
 rem ** --------------------------

 rem ** Every day your Stamina and Food levels decrease
   if Stamina>$02 then dec Stamina=Stamina-$02
   if scoreFoodLo>$03 then dec scoreFoodLo=scoreFoodLo-$03

 rem ** If your food reaches zero, you receive an additional stamina decrease daily.
   if scoreFoodLo=$00 && Stamina>$00 then dec Stamina=Stamina-$01

 rem ** if your Stamina reaches zero, your health decreases by 2 each day.
   if Stamina=$00 && Health>$01 then dec Health=Health-$02

 rem ** if you have $100 or more money in the bank, you will earn $500 a day in interest   >00 01 00
   if scoreBankHi>$95 then goto skip500
   if scoreBankMed>$00 then tempPriceHi=$00:tempPriceMed=$05:tempPriceLo=$00:gosub AddBank  

 rem ** Add an extra $1500 a day if your balance is $10,000 or more  >01 00 00
   if scoreBankHi>$95 then goto skip500
   if scoreBankHi>$00 then tempPriceHi=$00:tempPriceMed=$15:tempPriceLo=$00:gosub AddBank

skip500
 flagTravelLine=0
 return

sfxmovesound
 playsfx sfx_move_sound
 return 

sfxdeath
 playsfx sfx_death
 return

  rem ******************************************************
  rem **************** Purchase Subroutines ****************
  rem ******************************************************
  
completeBuyMatches
  dec ownMatches=ownMatches+buyMatches:    dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyMatches 
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyFirstAid
  dec ownFirstAid=ownFirstAid+buyFirstAid: dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyFirstAid
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyShovel
  dec ownShovel=ownShovel+buyShovel:       dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyShovel
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyRope
  dec ownRope=ownRope+buyRope:             dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyRope
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyCompass
  dec ownCompass=ownCompass+buyCompass:    dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyCompass
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyGPS
  dec ownGPS=ownGPS+buyGPS:                dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyGPS
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyFlare
  dec ownFlare=ownFlare+buyFlare:          dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyFlare
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyFuse
  dec ownFuse=ownFuse+buyFuse:             dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyFuse
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyClothes
  dec ownClothes=ownClothes+buyClothes:    dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyClothes
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyCanteen
  dec ownCanteen=ownCanteen+buyCanteen:    dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyCanteen
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return
completeBuyTobacco
  dec ownTobacco=ownTobacco+buyTobacco:    dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo+buyTobacco 
    gosub BuyQuantity: rem This reduces the amount of money you have when you purchase an item
  return

 data sfx_explode
  $10,$2F,$02 ; version, priority, frames per chunk
  $1A,$03,$0a ; first chunk of freq,channel,volume data 
  $1A,$08,$0E 
  $1A,$03,$0D 
  $1A,$08,$0C 
  $1A,$03,$0B 
  $1A,$08,$0A 
  $1A,$03,$09 
  $1A,$03,$02 
  $1A,$03,$09 
  $1A,$03,$02 
  $1A,$03,$09 
  $1A,$03,$02 
  $1A,$03,$09 
  $1A,$03,$09 
  $1F,$08,$08 
  $1F,$03,$07 
  $1F,$08,$06 
  $1F,$03,$05 
  $1F,$08,$04 
  $1F,$03,$03 
  $1F,$08,$02 
  $1F,$03,$01 
  $00,$00,$00 
end

 data sfx_death
  $10,$10,$02 ; version, priority, frames per chunk
  $10,$04,$0F ; first chunk of freq,channel,volume data 
  $11,$04,$0E 
  $12,$04,$0D 
  $13,$04,$0C 
  $14,$04,$0B 
  $15,$04,$0A 
  $16,$04,$09 
  $17,$04,$08 
  $18,$04,$07 
  $19,$04,$06 
  $1A,$04,$05 
  $1B,$04,$04 
  $1C,$04,$03 
  $1D,$04,$02 
  $1E,$04,$01 
  $00,$00,$00 
end

sfxhit
 playsfx sfx_hit
 return
 
sfxmenumove
 playsfx sfx_menu_move
 return

sfxmenubuysellmove
 playsfx sfx_menu_buysell_move
 return

completeSellMatches
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellMatches:            dec ownMatches=ownMatches-sellMatches
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellFirstAid
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellFirstAid:           dec ownFirstAid=ownFirstAid-sellFirstAid
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellShovel
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellShovel:             dec ownShovel=ownShovel-sellShovel
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellRope
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellRope:               dec ownRope=ownRope-sellRope
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellCompass
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellCompass:            dec ownCompass=ownCompass-sellCompass
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellGPS
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellGPS:                dec ownGPS=ownGPS-sellGPS
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellFlare
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellFlare:              dec ownFlare=ownFlare-sellFlare
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellFuse
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellFuse:               dec ownFuse=ownFuse-sellFuse
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellClothes
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellClothes:            dec ownClothes=ownClothes-sellClothes
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellCanteen
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellCanteen:            dec ownCanteen=ownCanteen-sellCanteen
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return
completeSellTobacco
  dec scoreUsedBackpackSpaceLo=scoreUsedBackpackSpaceLo-sellTobacco:            dec ownTobacco=ownTobacco-sellTobacco
    gosub SellQuantity: rem This increaes the amount of money you have when you sell an item
  return 

menumovedown
  if menubary=200 then return: rem don't allow moving down from Y200
  if !joy0down then menubary=menubary+8:return
  goto menumovedown
menumoveup
  if menubary=192 then return:rem don't allow moving up from Y192
  if !joy0up then menubary=menubary-8:return
  goto menumoveup

travelmenumovedown
  if City=6 then return
  if !joy0down then City=City+1:return
  goto travelmenumovedown
travelmenumoveup
  if City=1 then return
  if !joy0down then City=City-1:return
  goto travelmenumoveup
  
  rem **************************************************************
  rem **************** Statistics Screen Subroutine ****************
  rem **************************************************************

screenStats
 debounce=0
  rem  City=1:daysleft=$31:GameOver=0:CharismaFlag=0:BackpackFlag=0

screenStatsLoop
 drawwait
 clearscreen

 ;gosub logoDisplay
 gosub plottopLeftLine
 gosub JoystickLeftButton 
 gosub plotCommonScreenText
 gosub plotCityName
 gosub plotBottomLine27
 gosub plotValues

 rem ** Plot text for Statistics Screen
 rem ** -------------------------------
 plotvalue dm_scoredigits 1 statCountTraining 2 70 16
 plotvalue dm_scoredigits 1 statDexterityBonus 2 70 17
 plotvalue dm_scoredigits 1 statCharismaBonus 2 70 18
 plotvalue dm_scoredigits 1 statCriminalsKilled 2 70 19
 plotvalue dm_scoredigits 1 statDaysRested 2 70 20
 plotvalue dm_scoredigits 1 statBankTransactions 2 70 21

 plotchars 'Times Trained' 4 0 16
 plotchars 'Dex Bonus' 4 0 17  
 plotchars 'Charisma Bonus' 4 0 18
 plotchars 'Gangs Killed' 4 0 19 
 plotchars 'Days Rested' 4 0 20  
 plotchars 'Bank Transfers' 4 0 21

 plotchars 'Left fire exits' 7 0 24

 rem if GameOver=1 || Death>0 then rankFlag=1:goto theEnd
 rem if daysleft=$00 then goto theEnd

 if GameOver<>1 && debounce=1 then menubarx=32:menubary=200:debounce=0:gosub sfxmovesound:rankFlag=0:gosub resetFlags:Death=0:return

 plotbanner dm_hero2 4 138 176

 drawscreen
 goto screenStatsLoop

theEnd
  if Health<$01 then Death=1
theEndLoop
  drawwait
  clearscreen
  gosub logoDisplay
  rem ** Game is over, plot text based on how the game ended.
                                        plotchars 'Game Over' 7 46 20
  if Death<>1 && rolloverFlag<>1 then   plotchars 'Time is up' 7 46 21
                                        plotchars 'Left Fire Restarts' 4 46 25 
  if Death=1 then                       plotchars 'You Died' 6 46 21

  plotchars 'Credits $' 3 47 16     
  plotchars 'Bank    $' 3 47 17
  plotchars 'Debt    $' 3 47 18
  plotvalue dm_scoredigits 3 score1 6 86 16: rem **Credits 
  plotvalue dm_scoredigits 3 score4 6 86 17: rem **Bank
  plotvalue dm_scoredigits 3 score5 6 86 18: rem **Debt

  ;-------------------------------------------------------------------------------------------
  ; Rankings            Credits     Bank        Debt        (Credits OR Bank balance rank you)
  ;-------------------------------------------------------------------------------------------
  ;   Grand Master      999,999+    N/A         N/A
  ;   Master            600,000+ or 600,000+     0 
  ;   Hero              400,000+ or 400,000+     0
  ;   Guardian          300,000+ or 300,000+     0
  ;   Soldier           200,000+ or 200,000+     0
  ;   Fighter           150,000+ or 150,000+     0
  ;   Scout             100,000+ or 100,000+     0
  ;   Wanderer          50,000+  or 50,000+      0
  ;   Peasant           *Lowest Rank (Credits, Bank, Debt don't matter)
  ;-------------------------------------------------------------------------------------------
  rem If you rolled the score over, you are a true master of this game!
  plotchars 'Rank:' 7 46 22
  if rolloverFlag=1 then plotchars 'Grand Master' 5 68 22:goto rankComplete 
  rem If you have any debt at all, except if you earn 999,999+, you get the lowest ranking.
  if scoreDebtMed>$00 || scoreDebtHi>$00 then goto rankPeasant
rankGrandMaster
  rem Credits: $600,000 or more *OR* Bank: $600,000 or more 
  if scoreCreditsHi>$59 || scoreBankHi>$59 then plotchars 'Master' 5 68 22:goto rankComplete 
  ;----------------------------------------------------------------------------------
rankMaster
  rem Credits: $400,000 or more *OR* Bank: $400,000 or more 
  if scoreCreditsHi>$39 || scoreBankHi>$39 then plotchars 'Hero' 5 68 22:goto rankComplete 
  ;----------------------------------------------------------------------------------
rankGuardian
  rem Credits: $300,000 or more *OR* Bank: $300,000 or more 
  if scoreCreditsHi>$29 || scoreBankHi>$29 then plotchars 'Guardian' 5 68 22:goto rankComplete
  ;----------------------------------------------------------------------------------
rankSoldier
  rem Credits: $200,000 or more *OR* Bank: $200,000 or more 
  if scoreCreditsHi>$19 || scoreBankHi>$19 then plotchars 'Soldier' 5 68 22:goto rankComplete
  ;----------------------------------------------------------------------------------
rankFighter
  rem Credits: $150,000 or more *OR* Bank: $150,000 or more 
  if scoreCreditsHi>$14 || scoreBankHi>$14 then plotchars 'Fighter' 5 68 22:goto rankComplete
  ;----------------------------------------------------------------------------------
rankScout
  rem Credits: $100,000 or more *OR* Bank: $100,000 or more
  if scoreCreditsHi>$09 || scoreBankHi>$09 then plotchars 'Scout' 5 68 22:goto rankComplete
  ;----------------------------------------------------------------------------------
rankWanderer
  rem Credits: $50,000 or more *OR* Bank: $50,000 or more
  if scoreCreditsHi>$04 || scoreBankHi>$04 then plotchars 'Wanderer' 5 68 22:goto rankComplete
  ;----------------------------------------------------------------------------------
rankPeasant
  plotchars 'Peasant' 5 68 22
rankComplete

  gosub JoystickLeftButton 
  if debounce=1 then reboot

  drawscreen
 goto theEndLoop
                       dmahole 0 

beginText 
 plotchars 'Press Fire to Begin your Journey' 3 17 20
 return

 rem **Rank on GameOver
 rem ** score1 (Available Credits)  scoreCreditsHi=score1  scoreCreditsMed=score1+1  scoreCreditsLo=score1+2
 rem ** score4 (Bank Credits)       scoreBankHi=score4     scoreBankMed=score4+1     scoreBankLo=score4+2

 rem ****************************************************************
 rem **************** Price Randomization Subroutine ****************
 rem ****************************************************************

 rem ** This routine randomly adjusts the prices of the items when you travel to a new city.
 rem ** The routine includes modifiers for more dramatic increases and decreases in price when you travel (flagTravel)

PriceRandomization

  rem ** Matches
  rem ** Normal Price Range
  if flagTravel=11 || flagTravel=15 then SkipNormalMatchesPrice
  temp1=22:temp2=99:gosub setRandomPrice
  priceMatchesMed=rand&1 ; we can do this because decimal numbers <10 are equal to bcd numbers
  priceMatchesLo=tempscorezLo
SkipNormalMatchesPrice
         
        rem -- Decreased Price 
        if flagTravel<>11 then goto SkipDecreasedMatchesPrice
        temp1=0:temp2=1:gosub setRandomPrice
        priceMatchesMed=rand&1 ; we can do this because decimal numbers <10 are equal to bcd numbers
        priceMatchesLo=tempscorezLo
SkipDecreasedMatchesPrice

        rem ++ Increased Price
        if flagTravel<>15 then SkipIncreasedMatchesPrice
        temp1=1:temp2=05:gosub setRandomPrice
        priceMatchesMed=tempscorezLo
        temp1=0:temp2=99:gosub setRandomPrice  
        priceMatchesLo=tempscorezLo
SkipIncreasedMatchesPrice

  rem ** First Aid Kit 
  rem ** Normal Price Range Only  
  temp1=0:temp2=15:gosub setRandomPrice   
  priceFirstAidMed=tempscorezLo           
  temp1=12:temp2=99:gosub setRandomPrice  
  priceFirstAidLo=tempscorezLo            

  rem ** Shovel  
  rem ** Normal Price Range Only       
  temp1=01:temp2=14:gosub setRandomPrice  
  priceShovelMed=tempscorezLo             
  temp1=0:temp2=99:gosub setRandomPrice  
  priceShovelLo=tempscorezLo              

  rem ** Rope  (rope price) 
  rem ** Normal Price Range
  if flagTravel=12 then goto SkipDroppedRopePrice 
  temp1=65:temp2=59:gosub setRandomPrice       
  priceRopeMed=tempscorezLo               
  temp1=20:temp2=59:gosub setRandomPrice
  priceRopeLo=tempscorezLo                
SkipDroppedRopePrice

        rem -- Decreased Price
        if flagTravel<>12 then goto SkipDecreasedRopePrice
        priceRopeMed=$10           
        temp1=19:temp2=28:gosub setRandomPrice
        priceRopeLo=tempscorezLo  
SkipDecreasedRopePrice 

  rem ** Compass   
  rem ** Normal Price Range Only          
  temp1=0:temp2=04:gosub setRandomPrice
  priceCompassMed=tempscorezLo             
  temp1=0:temp2=99:gosub setRandomPrice
  priceCompassLo=tempscorezLo              
  
  rem ** GPS  
  rem ** Normal Price Range Only      
  temp1=22:temp2=41:gosub setRandomPrice
  priceGPSMed=tempscorezLo                
  temp1=9:temp2=99:gosub setRandomPrice
  priceGPSLo=tempscorezLo                  

  rem ** Flare    
  rem ** Normal Price Range Only       
  temp1=0:temp2=9:gosub setRandomPrice
  priceFlareMed=tempscorezLo               
  temp1=11:temp2=99:gosub setRandomPrice
  priceFlareLo=tempscorezLo                

  rem ** Fuse     
  rem ** Normal Price Range Only      
  temp1=1:temp2=16:gosub setRandomPrice
  priceFuseMed=tempscorezLo               
  temp1=99:temp2=00:gosub setRandomPrice
  priceFuseLo=tempscorezLo                 

  rem ** Clothes
  rem ** Normal Price Range Only 
  temp1=1:temp2=10:gosub setRandomPrice
  priceClothesMed=tempscorezLo
  temp1=99:temp2=00:gosub setRandomPrice
  priceClothesLo=tempscorezLo

  rem ** Canteen
  rem ** Normal Price Range
  if flagTravel=13 || flagTravel=16 then goto SkipNormalCanteenPrice
  priceCanteenMed=01
  temp1=0:temp2=99:gosub setRandomPrice
  priceCanteenLo=tempscorezLo
SkipNormalCanteenPrice

        rem ++ Increased Price
        if flagTravel<>13 then goto SkipIncreasedCanteenPrice
        priceCanteenMed=03
        temp1=0:temp2=99:gosub setRandomPrice
        priceCanteenLo=tempscorezLo
SkipIncreasedCanteenPrice

        rem -- Decreased Price
        if flagTravel<>16 then goto SkipDecreasedCanteenPrice
        priceCanteenMed=0
        temp1=12:temp2=46:gosub setRandomPrice
        priceCanteenLo=tempscorezLo
SkipDecreasedCanteenPrice
 
  rem ** Tobacco
  rem ** Normal Price Range
  if flagTravel=14 || flagTravel=17 then goto SkipNormalTobaccoPrice
  temp1=22:temp2=99:gosub setRandomPrice
  priceTobaccoMed=rand&1
  priceTobaccoLo=tempscorezLo
SkipNormalTobaccoPrice

TobaccoChange
        rem -- Decreased Price
        if flagTravel<>17 then goto SkipDecreasedTobaccoPrice
        priceTobaccoMed=0
        priceTobaccoLo=rand&7
        if priceTobaccoLo<1 then goto TobaccoChange
SkipDecreasedTobaccoPrice

        rem ++ Increased Price
        if flagTravel<>14 then goto SkipIncreasedTobaccoPrice
        priceTobaccoMed=02
        temp1=0:temp2=99:gosub setRandomPrice
        priceTobaccoLo=tempscorezLo
SkipIncreasedTobaccoPrice

 return

  rem *********************************************************
  rem **************** Plot Values Subroutines ****************
  rem *********************************************************

plotValues
 rem ** Plot all Stats on the top of the main screen
 plotvalue dm_scoredigits 0 daysleft 2 1 1:       rem **Plot Days remaining variable (daysleft)
 plotvalue dm_scoredigits 3 score5 6 46 5:        rem **Debt
 plotvalue dm_scoredigits 0 ownKnives 2 45 7:     rem **Knives
 plotvalue dm_scoredigits 0 Health 2 45 8:        rem **Health
 plotvalue dm_scoredigits 0 scoreUsedBackpackSpaceLo 2 45 9:  rem **Space Consumed
 plotvalue dm_scoredigits 0 scoreTotalBackpackSpaceLo 2 57 9:  rem **Space
 plotvalue dm_scoredigits 0 scoreFoodLo 2 45 10:   rem **Food
 plotvalue dm_scoredigits 0 Stamina 2 45 11:      rem **Stamina
 plotvalue dm_scoredigits 0 Charisma 2 45 12:     rem **Charisma
 plotvalue dm_scoredigits 0 Dexterity 2 45 13:    rem **Dexterity

 rem ** List of Quantities Owned
 plotvalue dm_scoredigits 2 ownMatches 2 150 3
 plotvalue dm_scoredigits 2 ownFirstAid 2 150 4
 plotvalue dm_scoredigits 2 ownShovel 2 150 5
 plotvalue dm_scoredigits 2 ownRope 2 150 6
 plotvalue dm_scoredigits 2 ownCompass 2 150 7
 plotvalue dm_scoredigits 2 ownGPS 2 150 8
 plotvalue dm_scoredigits 2 ownFlare 2 150 9
 plotvalue dm_scoredigits 2 ownFuse 2 150 10
 plotvalue dm_scoredigits 2 ownClothes 2 150 11
 plotvalue dm_scoredigits 2 ownCanteen 2 150 12
 plotvalue dm_scoredigits 2 ownTobacco 2 150 13

 rem ** Price of items 
 plotvalue dm_scoredigits 7 priceMatchesMed  4 129 3
 plotvalue dm_scoredigits 7 priceFirstAidMed 4 129 4
 plotvalue dm_scoredigits 7 priceShovelMed 4 129 5
 plotvalue dm_scoredigits 7 priceRopeMed 4 129 6
 plotvalue dm_scoredigits 7 priceCompassMed 4 129 7
       dmahole 1
 plotvalue dm_scoredigits 7 priceGPSMed 4 129 8
 plotvalue dm_scoredigits 7 priceFlareMed 4 129 9

 plotvalue dm_scoredigits 7 priceFuseMed 4 129 10

 plotvalue dm_scoredigits 7 priceClothesMed 4 129 11
 plotvalue dm_scoredigits 7 priceCanteenMed 4 129 12
 plotvalue dm_scoredigits 7 priceTobaccoMed 4 129 13
 plotvalue dm_scoredigits 3 score4 6 46 4:        rem **Bank
 plotvalue dm_scoredigits 3 score1 6 46 3:        rem **Credits ($Money)
 return

  data sfx_heartbeat1
  $10,$04,$14 ; version, priority, frames per chunk
  $18,$06,$04 ; first chunk of freq,channel,volume data 
  $10,$06,$00
  $00,$00,$00 
end

  data sfx_menumove
  $10,$10,$02 ; version, priority, frames per chunk
  $08,$03,$02 ; first chunk of freq,channel,volume data 
  $14,$04,$04
  $00,$00,$00 
end

  data sfx_menuselect
  $10,$04,$02 ; version, priority, frames per chunk
  $00,$06,$05 ; first chunk of freq,channel,volume data 
  $01,$06,$02 
  $02,$06,$01 
  $03,$06,$01
  $00,$00,$00 
end

 data copyrightsfx
  $10,$08,$08 ; version, priority, frames per chunk
  $18,$06,$0a ; first chunk of freq,channel,volume data 
  $08,$06,$0a
  $01,$00,$00 
  $18,$06,$05
  $08,$06,$05
  $01,$00,$00 
  $18,$06,$04
  $08,$06,$04
  $01,$00,$00 
  $18,$06,$03
  $08,$06,$03
  $01,$00,$00 
  $18,$06,$02
  $08,$06,$02
  $01,$00,$00 
  $18,$06,$01
  $08,$06,$01
  $00,$00,$00 
end

 data sfx_menu_buysell_move
 $10,$10,$00 
 $00,$04,$00 
 $03,$06,$0c
 $0d,$0c,$0f
 $1b,$04,$04
 $06,$0c,$00
 $00,$06,$00
 $07,$06,$00
 $10,$0c,$00
 $0d,$0c,$00
 $10,$0c,$00
 $03,$06,$00
 $10,$0c,$00
 $1b,$04,$00
 $10,$0c,$00
 $10,$0c,$00
 $03,$06,$00
 $00,$00,$00
end

 data sfx_move_sound
 $10,$10,$00 
 $1c,$04,$07
 $1b,$04,$07
 $04,$0f,$05
 $15,$04,$09
 $16,$04,$07
 $03,$0f,$04
 $11,$04,$08
 $11,$04,$08
 $11,$04,$04
 $0e,$04,$09
 $0e,$04,$07
 $0e,$04,$04
 $1c,$04,$07
 $1b,$04,$05
 $1c,$04,$04
 $1b,$04,$02
 $00,$00,$00
end

 data sfx_hit
 $10,$10,$02
 $1F,$03,$0F 
 $1F,$08,$0E 
 $1F,$03,$0D 
 $1F,$08,$0C 
 $1F,$03,$0B 
 $1F,$08,$0A 
 $1F,$03,$09 
 $1F,$08,$08 
 $1F,$03,$07 
 $1F,$08,$06 
 $1F,$03,$05 
 $1F,$08,$04 
 $1F,$03,$03 
 $1F,$08,$02 
 $1F,$03,$01 
 $00,$00,$00 
end

 data sfx_menu_move
 $10,$01,$02 
 $06,$04,$0F 
 $0C,$04,$08 
 $18,$04,$04 
 $31,$04,$02 
 $00,$00,$00
end

 data sfx_option_select
 $10,$10,$00
 $00,$04,$00 
 $03,$06,$0c
 $00,$00,$00
end

clearQuantities
 rem ** Clear buy Quantities
 buyKnives=0:     buyFood=0:       buyMatches=0
 buyFirstAid=0:   buyShovel=0:     buyRope=0
 buyCompass=0:    buyGPS=0:        buyFlare=0
 buyFuse=0:       buyClothes=0:    buyCanteen=0
 buyTobacco=0
 
 rem ** Clear sell Quantities
 sellKnives=0:    sellFood=0:      sellMatches=0
 sellFirstAid=0:  sellShovel=0:    sellRope=0
 sellCompass=0:   sellGPS=0:       sellFlare=0
 sellFuse=0:      sellClothes=0:   sellCanteen=0
 sellTobacco=0

  rem ** Reset temp variables
  rem uncommented 7/1/22
 tempQty=0:       tempPriceLo=$00:     tempPriceMed=$00
 tempPriceHi=$00

 return

resetSelect
 rem ** Reset Selections
 selectMatches=0: selectFirstAid=0: selectShovel=0
 selectRope=0:    selectCompass=0:  selectGPS=0
 selectFlare=0:   selectFuse=0:     selectClothes=0
 selectCanteen=0: selectTobacco=0:  selectDone=0
 return

resetFlags
 rem ** Set all flags to 0
 flagItem=0:     flagLender=0:    flagFight=0
 flagBuy=0:      flagSell=0:      flagTravel=0
 flagDoctor=0:   flagTrain=0:     flagBank=0
 flagRest=0:     flagAttacked=0:  flagStats=0
 debounce=0

 return

menuSelectionMatches
 selectMatches=1:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionFirstAid 
 selectMatches=0:selectFirstAid=1:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionShovel
 selectMatches=0:selectFirstAid=0:selectShovel=1:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionRope
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=1:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionCompass
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=1:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionGPS
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=1:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionFlare 
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=1:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionFuse
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=1:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionClothes
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=1:selectCanteen=0:selectTobacco=0:selectDone=0
 return
menuSelectionCanteen
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=1:selectTobacco=0:selectDone=0
 return
menuSelectionTobacco
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=1:selectDone=0
 return
menuSelectionDone
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=1
 return
menuClearSelections
 selectMatches=0:selectFirstAid=0:selectShovel=0:selectRope=0:selectCompass=0:selectGPS=0:selectFlare=0:selectFuse=0:selectClothes=0:selectCanteen=0:selectTobacco=0:selectDone=0
 return

plotCityName

 rem ** This subroutine plots the name of the city on line 13.
 
 rem ** New Vegas (City 1)
 rem Unique Option: Doctor
 rem Disable Options: Lender, Deposit, Withdrawal, Rest, Training Facility
 rem                     5       2         7        10       4   
 rem 
 if City<>1 then goto skipCity1
 plotchars 'New Vegas' 3 56 27
skipCity1

 rem ** Lost Angeles (City 2)
 rem Unique Options: Lender, Bank Depost, Bank withdrawal 
 rem Disable Options: Doctor, Rest, Training Facility
 rem 
 if City<>2 then goto skipCity2:
 plotchars 'Lost Angeles' 3 50 27
skipCity2

 rem ** New Salem (City 3)
 rem Unique Options: Training Facility
 rem Disable Options: Doctor, Lender, Deposit, Withdrawal, Rest
 rem 
 if City<>3 then goto skipCity3
 plotchars 'New Salem' 3 56 27
skipCity3

 rem ** Concord (City 4)
 rem Unique Options: None
 rem Disable Options: Doctor, Lender, Deposit, Withdrawal, Rest, Training Facility
 rem
 if City<>4 then goto skipCity4
 plotchars 'Concord' 3 60 27
skipCity4

 rem ** Diamond City (City 5)
 rem Unique Options: None
 rem Disable Options: Doctor, Lender, Deposit, Withdrawal, Rest, Training Facility
 rem 
 if City<>5 then goto skipCity5
 plotchars 'Diamond City' 3 48 27
skipCity5

 rem ** Bedford (City 6)
 rem Unique Options: Rest 
 rem Disable Options: Doctor, Lender, Deposit, Withdrawal, Training Facility
 rem 
 if City<>6 then goto skipCity6
 plotchars 'Bedford Falls' 3 48 27
skipCity6

 return



  rem ********************************************************
  rem **************** Math Helper Subroutines ***************
  rem ********************************************************
  
setRandomPrice    rem given minimum and maximum decimal values between 01 and 99, set a random BCD value between them
  rem ** Input: temp1(minimum) temp2(maximum)
  rem ** Output: tempscorezLo
  tempscorezLo=0
  ; get tempscorezLo to our minimum value
  for temp3=0 to temp1
  dec tempscorezLo=tempscorezLo+$01
  next
  temp2=temp2-temp1
  rem ** the following bit of code finds a nice bitmask, so we don't spend a long time 
  rem ** searching for a suitable random within our range...
  temp5=127
  if temp2<64 then temp5=63
  if temp2<32 then temp5=31
  if temp2<16 then temp5=15
  if temp2<8 then temp5=7
getSuitableRand
  temp4=rand&temp5
  if temp4=0 then return
  if temp4>temp2 then goto getSuitableRand
  for temp3=0 to temp4
  dec tempscorezLo=tempscorezLo+$01

  next
  return

checkMaximumQuantity
  rem ** measure what quantity of an item the player can buy   
  rem ** Input: tempPriceMed+tempPriceLo
  rem ** Output: tempQty
  tempQty=0:scorex=0 ; ** clear the quantity and temporary score

checkMaximumQuantityLoop
    rem ** here we repeatedly add our price to the 24-bit temp score, until it exceeds the credits...
    ;The block of asm below replaces the three lines of basic code below, which do not function properly.
    ;dec tempscorexLo=tempscorexLo+tempPriceLo
    ;if CARRY then  dec tempscorexMed=tempscorexMed+tempPriceMed+1 else  dec tempscorexMed=tempscorexMed+tempPriceMed
    ;if CARRY then  dec tempscorexHi=tempscorexHi+tempPriceHi+1    else  dec tempscorexHi=tempscorexHi+tempPriceHi
 asm
    sed
    lda tempscorexLo
    clc
    adc tempPriceLo
    sta tempscorexLo
    lda tempscorexMed
    adc tempPriceMed
    sta tempscorexMed
    lda tempscorexHi
    adc tempPriceHi
    sta tempscorexHi
    cld
end
    rem
    rem ** check if we've exceeded the player's credits...
    if scoreCreditsHi<tempscorexHi then goto checkMaximumQuantityDone
    if scoreCreditsHi>tempscorexHi then goto checkMaximumQuantityContinue
    if scoreCreditsMed<tempscorexMed then goto checkMaximumQuantityDone
    if scoreCreditsMed>tempscorexMed then goto checkMaximumQuantityContinue
    if scoreCreditsLo<tempscorexLo then goto checkMaximumQuantityDone
checkMaximumQuantityContinue
    if tempQty=$99 then goto checkMaximumQuantityDone
    dec tempQty=tempQty+1 ; ** if we're here, we were able to "buy" 1 more with our credits
  goto checkMaximumQuantityLoop ; ** so lets try to "buy" some more!
checkMaximumQuantityDone
  return 
         dmahole 2
BuyQuantity 
  rem *** decrease the credits due to a purchase
  rem ** Input: tempPriceHi+tempPriceMed+tempPriceLo,tempQty
  rem ** Output: none (score1 is modified, tempQty is destroyed)
BuyQuantityLoop
   asm
    sed
    lda scoreCreditsLo
    sec
    sbc tempPriceLo
    sta scoreCreditsLo
    lda scoreCreditsMed
    sbc tempPriceMed
    sta scoreCreditsMed
    lda scoreCreditsHi
    sbc tempPriceHi
    sta scoreCreditsHi
    cld
end

  dec tempQty=tempQty-1
  if tempQty>0 then goto BuyQuantityLoop
  return 
SellQuantity 
  rem *** increase credits due to a sale
  rem ** Input: tempPriceHi+tempPriceMed+tempPriceLo,tempQty
  rem ** Output: none (score1 is modified, tempQty is destroyed)
SellQuantityLoop
   asm
    sed
    lda scoreCreditsLo
    clc ;sec
    adc tempPriceLo
    sta scoreCreditsLo
    lda scoreCreditsMed
    adc tempPriceMed
    sta scoreCreditsMed
    lda scoreCreditsHi
    adc tempPriceHi
    sta scoreCreditsHi
    cld
end
  gosub rollover
  dec tempQty=tempQty-1
  if tempQty>0 then goto SellQuantityLoop
  return

AddDebt
   asm
    sed
    lda scoreDebtLo
    clc ;sec
    adc tempPriceLo
    sta scoreDebtLo
    lda scoreDebtMed
    adc tempPriceMed
    sta scoreDebtMed
    lda scoreDebtHi
    adc tempPriceHi
    sta scoreDebtHi
    cld
end
  return 

SubtractDebt
   asm
    sed
    lda scoreDebtLo
    sec
    sbc tempPriceLo
    sta scoreDebtLo
    lda scoreDebtMed
    sbc tempPriceMed
    sta scoreDebtMed
    lda scoreDebtHi
    sbc tempPriceHi
    sta scoreDebtHi
    cld
end
  return 

AddBank
   asm
    sed
    lda scoreBankLo
    clc ;sec
    adc tempPriceLo
    sta scoreBankLo
    lda scoreBankMed
    adc tempPriceMed
    sta scoreBankMed
    lda scoreBankHi
    adc tempPriceHi
    sta scoreBankHi
    cld
end
  return 

SubtractBank
   asm
    sed
    lda scoreBankLo
    sec
    sbc tempPriceLo
    sta scoreBankLo
    lda scoreBankMed
    sbc tempPriceMed
    sta scoreBankMed
    lda scoreBankHi
    sbc tempPriceHi
    sta scoreBankHi
    cld
end
  return 
AddCredits
   asm
    sed
    lda scoreCreditsLo
    clc ;sec
    adc tempPriceLo
    sta scoreCreditsLo
    lda scoreCreditsMed
    adc tempPriceMed
    sta scoreCreditsMed
    lda scoreCreditsHi
    adc tempPriceHi
    sta scoreCreditsHi
    cld
end
  gosub rollover
  return 
SubtractCredits
   asm
    sed
    lda scoreCreditsLo
    sec
    sbc tempPriceLo
    sta scoreCreditsLo
    lda scoreCreditsMed
    sbc tempPriceMed
    sta scoreCreditsMed
    lda scoreCreditsHi
    sbc tempPriceHi
    sta scoreCreditsHi
    cld
end
  return   

 rem ********************************************************
 rem **************** Titlescreen Subroutine ****************
 rem ********************************************************

titlescreen
 rem **set color of 320A text palettes
 P0C2=$06: rem Grey         
 P1C2=$04: rem Dark Grey
 P2C2=$18: rem Light Yellow 
 P3C2=$C4: rem Green 
 P4C2=$84: rem Blue         
 P5C2=$36: rem Orange
 P6C2=$44: rem Light Red    
 P7C2=$F6: rem Dark Yellow
 logoY1=56
 logoY2=64
 logoY3=72
 logoY4=80
 logoY5=56
 logoY6=64
 logoY7=72
 logoY8=80
date
  clearscreen
  fadeindex=fadeindex+1
  if fadeindex<127 then fadeluma=fadeindex/8
  if fadeindex>136 then fadeluma=32-(fadeindex/8)
  P0C2=fadeluma
  if fadeindex=81 then playsfx copyrightsfx
  plotchars 'Presents...' 0 56 16
  gosub AALogoDraw
  drawscreen
  gosub JoystickLeftButton
  if debounce=1 then debounce=0:goto screenWelcome
  if fadeindex>0 then goto date
copyright
  clearscreen
  fadeindex=fadeindex+1
  if fadeindex<127 then fadeluma=fadeindex/8
  if fadeindex>136 then fadeluma=32-(fadeindex/8)
  P0C2=fadeluma
  if fadeindex=81 then playsfx copyrightsfx
  plotchars    'A Game By' 0 58 14
  plotchars 'Steve Engelhardt' 0 45 16
  plotchars      '+ 2023' 0 62 18
  gosub AALogoDraw
  drawscreen
  gosub JoystickLeftButton
  if debounce=1 then debounce=0:goto screenWelcome
  if fadeindex>0 then goto copyright
intermission
  clearscreen
  fadeindex=fadeindex+1
  gosub AALogoDraw
  logoY1=logoY1+1:logoY2=logoY2+1:logoY3=logoY3+1:logoY4=logoY4+1:logoY5=logoY5+1:logoY6=logoY6+1:logoY7=logoY7+1:logoY8=logoY8+1
  drawscreen
  if fadeindex<130 then goto intermission

  rem *****************************************
  rem **************** Welcome ****************
  rem *****************************************

screenWelcome

  playsfx sfx_hit

 rem ** Set variables 
 debounce=0
 P0C2=$0F: rem White       
 P1C2=$06: rem Dark Grey
 P2C2=$16: rem Light Yellow 
 P6C2=$40: rem Light Red    
 P7C2=$16: rem Dark Yellow

 ;P4C2=$88: rem Blue         
 ;P5C2=$28: rem Orange

 P4C2=$84: rem Blue         
 P5C2=$36: rem Orange

 logoY1=184
 logoY2=192
 logoY3=200
 logoY4=208
 logoY5=184
 logoY6=192
 logoY7=200
 logoY8=208
 heroX=158

screenWelcomeLoop 
 ;drawwait
 clearscreen

 menuColor=rand&7
 fadeindex=fadeindex+1
  if fadeindex<127 then fadeluma=fadeindex/8
  if fadeindex>136 then fadeluma=32-(fadeindex/8)
 P3C2=fadeluma

 rem box pattern
 rem    -***************************-
 rem    #                           #
 rem    \;;;;;;;;;;;;;;;;;;;;;;;;;;;\
 rem 

 plotchars '-####]-' 6 82 6
 plotchars '#######' 6 82 7
 plotchars '\#####\' 6 82 8

 plotchars '[' 1 44 14
 plotchars '################]' 1 44 15


 ;plotbanner dm_criminal4 5 30 50
 ;plotbanner dm_hero2 4 112 50
 gosub logoDisplay
 plotchars 'Welcome to the Apocalypse' 1 30 17
 gosub beginText

 plotsprite myname2 1 heroX 208 ;53 to center
 if heroX>62 then heroX=heroX-2

 gosub JoystickLeftButton
 if debounce=1 then debounce=0:playsfx sfx_explode: rolloverCheck=scoreCreditsHi:goto start

  soundcounter=soundcounter+1
  if soundcounter>50 then soundcounter=0
  if soundcounter<>1 then goto skipbeatsound
   playsfx sfx_heartbeat1
skipbeatsound

 gosub AALogoDraw
 drawscreen

 goto screenWelcomeLoop

logoDisplay
 plotbanner dm_logo1a 1 47 18
 plotbanner dm_logo2a 1 47 26
 plotbanner dm_logo3a 1 47 34
 plotbanner dm_logo4a 1 47 42
 plotbanner dm_logo5a 1 47 50
 plotbanner dm_logo6a 1 47 58
 plotbanner dm_logo7a 1 47 66
 plotbanner dm_logo8a 1 47 74
 plotbanner dm_logo9a 1 47 82
 plotbanner dm_logo10a 1 47 90
 plotbanner dm_logo11a 1 47 98
 plotbanner dm_logo12a 1 47 106
 plotbanner dm_logo13a 1 47 114
 ;plotsprite dm_icon_canteen 6 67 68 
 ;plotsprite dm_icon_canteen 6 77 72 
 return

AALogoDraw
  plotsprite aa_left_1b 4 45 logoY1
  plotsprite aa_left_2b 4 45 logoY2
  plotsprite aa_left_3b 4 45 logoY3
  plotsprite aa_left_4b 4 45 logoY4
  plotsprite aa_right_1 5 85 logoY5
  plotsprite aa_right_2 5 85 logoY6
  plotsprite aa_right_3 5 85 logoY7
  plotsprite aa_right_4 5 85 logoY8
 return



