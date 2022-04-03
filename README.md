# Sha1-cpp-Verilog
knu 2021 digital design &amp; lab Project, Sha-1 Algorithm (without padding, only input 512 bits)
<br><br>
## Introduce

디지털 설계 및 실험 과목 최종 프로젝트로, [Sha1 알고리즘](https://ko.wikipedia.org/wiki/SHA-1) 을 Cpp 및 Verilog로 구현 하였습니다. 
<br> `※Padding 기능은 제외하였습니다.` <br><br>

## Source Code Description
### `1. C++ Source Code Description`

(1) length가 128 (512bit) 인 문자열을 입력으로 받습니다.<br><br>
(2) 문자열을 하나씩 Char로 parsing하여 16진수로 변환후에 배열 M에 넣습니다.<br><br>
    - M은 32bit형의 배열입니다.
    
    
<img width="619" alt="1" src="https://user-images.githubusercontent.com/75191916/161426945-1453c4c8-a436-43ac-b386-16f84f2e9bc3.png">

(3) 입력 값으로 채울 수 있는 W[0] ~ W[15] 값을 채웁니다.
<img width="1060" alt="2" src="https://user-images.githubusercontent.com/75191916/161427041-f2c7aa49-31da-4137-a3ad-dffcb186210f.png">

W는 배열마다 1개의 Word 로 되어있습니다. (32bit)  <br>
M에서 길이 8의 단위로 가져와 1Word를 만듭니다. <br>
이때 각 숫자의 가중치가 다르기 때문에 shift를 해주어야 합니다. <br><br>

/* <br>
Ex> <br>
1011_0011-> 0001 0000 0001 0001 _ 0000 0000 0001 0001 입니다. <br>
M의 저장되어 있는 16진수 값들은 32bit로 저장되어 있기에, 가장 앞의 1이라고 하면 <br>
0000 0000 0000 0000 _ 0000 0000 0000 0001 형태를 지니고 있습니다. <br>
Left Shift 28 수행하여 0001 0000 0000 0000 _ 0000 0000 0000 0000 로 만들어 줍니다. <br> */

가중치에 맞게 Left Shift를 해주고 마지막으로 OR연산을 진행해주어 1개의 Word를 완성시킵니다. <br><br>

<img width="1054" alt="3" src="https://user-images.githubusercontent.com/75191916/161427064-d675fcef-3c55-422a-b04a-ffa7d28cf4f6.png">

(5) 초기 a, b, c, d, e 값을 초기화 해줍니다. 값은 배열 h에 저장해 두었습니다

<img width="289" alt="4" src="https://user-images.githubusercontent.com/75191916/161427074-e4d702fd-563b-4fbb-8121-c8a7b192b81d.png">

(6) 총 80번의 연산을 진행하면서 최종 a, b, c, d, e 값을 도출합니다.
연산은 기본 SHA1알고리즘을 따르며 연산 20번마다 지정된 k값을 설정해줍니다.

<img width="500" alt="5" src="https://user-images.githubusercontent.com/75191916/161427078-e259d089-62f4-487b-af29-3d4e2cd97b79.png">

(7) 최종적으로 계산된 a, b, c, d, e 값과 초기값을 더해줘서 최종 output을 만들어 냅니다.


<img width="593" alt="6" src="https://user-images.githubusercontent.com/75191916/161427095-bb6da928-f8e0-4899-b100-a73716482a14.png">

- 디버깅 코드까지 포함하여 출력한 결과



### `2. Verilog Source Code Description`
변수 및 벡터 설명 <br>
- Input <br>
  - [511:0] SHA1IN : 512bit의 입력 값 <br>
  - CLK : 주기적으로 반복되는 clock (posedge) <br>
  - START : Operation을 시작하는 신호 (1Cycle 유지) <br>
  - nRST : Reset 신호 (negedge), 0이 들어오면 초기화 된다. <br><br>
- Output <br>
  - [159:0] SHA1OUT : 160bit의 출력 값 <br>
  - DONE : Operation이 끝났음을 알리는 신호 (1Cycle 유지)<br><br>
- In sha1 module<br>
  - [31:0] W [79:0] : 32bit의 워드를 저장할 수 있는 벡터 배열<br>
  - [31:0] H [4:0] : 초기 A, B, C, D, E 에 들어가는 값 저장<br>
  - State : START 신호가 들어왔었는지 저장용<br>
  - [7:0] t : rotation shift용 reg<br>
(1) Input으로 512bit의 SHA1IN을 입력 받습니다 <br>

<img width="463" alt="7" src="https://user-images.githubusercontent.com/75191916/161427169-1b935d3d-ac72-47e0-8035-b573898ce7ba.png">

(2) 1Word (32bit) 씩 Parsing하여 W[0] ~ W[15]를 채워 넣습니다 <br>
<img width="411" alt="8" src="https://user-images.githubusercontent.com/75191916/161427180-465cc9ce-56b1-49d4-a873-0265cc32e62c.png">

(3) 이후 지정된 식으로 W[16] ~ W[79] 또한 계산합니다 <br>
<img width="545" alt="9" src="https://user-images.githubusercontent.com/75191916/161427193-88b84d89-77de-45bf-859d-486163153793.png">

(4) 초기 A, B, C, D, E 값을 설정해줍니다. <br>
<img width="410" alt="10" src="https://user-images.githubusercontent.com/75191916/161427209-4a11feb5-bbbd-49db-9c68-6a5f050520b4.png">

- 초기값은 H벡터에 배열형태로 저장되어 있습니다.



<img width="386" alt="11" src="https://user-images.githubusercontent.com/75191916/161427218-a0465dac-9eba-4ffd-881f-34d4df38c4ae.png">


(5) START 신호가 들어오면 posedge CLK 일때마다 Operation 1개를 실행합니다. <br>
Operation을 수행할 때 마다 F값을 계산해주며 A, B, C, D, E 또한 갱신됩니다. <br>
<img width="459" alt="12" src="https://user-images.githubusercontent.com/75191916/161427226-e2a251c9-af33-425a-9e1c-d9769a08c81b.png">

(6) 최종적으로 계산된 A ~ E 값과 초기 A ~ E 값을 각각 더하여서 SHA1OUT 값을 만들어 냅니다.<br> 이때 최종 계산이 끝남과 동시에 DONE 신호를 띄웁니다.



<img width="319" alt="13" src="https://user-images.githubusercontent.com/75191916/161427230-30ea0612-46dc-44cf-98af-ce93d2bdce23.png">


Result
<img width="1019" alt="14" src="https://user-images.githubusercontent.com/75191916/161427249-e86dc6e2-8b8a-4891-b56d-f6fd3cc07d40.png">


INPUT (512 bit)  <br>
7465737480000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000
0000020 <br><br>
OUTPUT (160 bit) <br>
A94A8FE5 CCB19BA6 1C4C0873 D391E987 982FBBD3 <br>


