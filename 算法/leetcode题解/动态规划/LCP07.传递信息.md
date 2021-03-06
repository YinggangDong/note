# LCP 07. 传递信息

## 题干

```
小朋友 A 在和 ta 的小伙伴们玩传信息游戏，游戏规则如下：

有 n 名玩家，所有玩家编号分别为 0 ～ n-1，其中小朋友 A 的编号为 0
每个玩家都有固定的若干个可传信息的其他玩家（也可能没有）。传信息的关系是单向的（比如 A 可以向 B 传信息，但 B 不能向 A 传信息）。
每轮信息必须需要传递给另一个人，且信息可重复经过同一个人
给定总玩家数 n，以及按 [玩家编号,对应可传递玩家编号] 关系组成的二维数组 relation。返回信息从小 A (编号 0 ) 经过 k 轮传递到编号为 n-1 的小伙伴处的方案数；若不能到达，返回 0。

示例 1：

输入：n = 5, relation = [[0,2],[2,1],[3,4],[2,3],[1,4],[2,0],[0,4]], k = 3

输出：3

解释：信息从小 A 编号 0 处开始，经 3 轮传递，到达编号 4。共有 3 种方案，分别是 0->2->0->4， 0->2->1->4， 0->2->3->4。

示例 2：

输入：n = 3, relation = [[0,2],[2,1]], k = 2

输出：0

解释：信息不能从小 A 处经过 2 轮传递到编号 2

限制：

2 <= n <= 10
1 <= k <= 5
1 <= relation.length <= 90, 且 relation[i].length == 2
0 <= relation[i][0],relation[i][1] < n 且 relation[i][0] != relation[i][1]

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/chuan-di-xin-xi
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。
```

## 代码

### DP解法

动态规划，状态转移的关系是 

第i+1轮传递给编号j的方案数=第i轮传递给编号from（i轮有多少个传递给j的关系，就有多少个from）的方案数之和。

```java
class Solution {
    public int numWays(int n, int[][] relation, int k) {
        //dp[i][j] 经过i轮传递到j的玩家的方案数
        int[][] dp = new int[k+1][n];
        //第0轮到达编号0的接收方案有1个，其他接收方都是0
        dp[0][0] = 1;
        for(int i = 0;i<k;i++){
            //遍历关系数组
            for(int[] item:relation){
                //from 代表传递方 to代表接收方
                int from = item[0];
                int to = item[1];
                //i+1轮到达接收方的方案=i轮到达from(多个)的方案之和
                dp[i+1][to] += dp[i][from]; 
            }
        }
        //返回第k轮到达n-1编号的方案数
        return dp[k][n-1];
    }
}
```

### BFS解法

```java
class Solution {
    public int numWays(int n, int[][] relation, int k) {
        Queue<Integer> queue = new LinkedList<>();
        //记录当前传递轮次
        int step = 0;
        queue.offer(0);
        while(!queue.isEmpty()&&step<k){
            step++;
            //当前轮次的队列的元素数量
            int size = queue.size();
            for(int i= 0;i<size;i++){
                //获取队头元素
                int cur = queue.poll();
                for(int[] item:relation){
                    //如果关系的传递方是队头元素，则将接收方放到queue中
                    if(item[0] == cur){
                        queue.offer(item[1]);
                    }
                }
            }
        }
        //记录第k轮达到编号n-1的方案数
        int count = 0;
        //如果step不等于k，说明是queue为空结束的while，说明没有到达n-1的路径
        if(step == k){
            //遍历k轮的queue队列
            while(!queue.isEmpty()){
                //判断k轮后指向的玩家编号，若为n-1，则满足要求
                if(queue.poll()==n-1){
                    count++;
                }
            }
        }
        return count;
    }
}
```

## 复杂度分析

### DP解法

- 时间复杂度：经过k轮，每轮会遍历一次关系数组，所以时间复杂度为O(k*m)，其中m为relation数组的长度
- 空间复杂度：过程中通过 dp 二维数组记录了k轮到达编号为n的玩家的方案数，所以O（k*n）

### BFS解法

- 时间复杂度：经过k轮，每轮分支有n个,每个分支都需要遍历relation，所以为 O(n^k^)。
- 空间复杂度：O(n+m+n^k^ )。其中 mm 为relation 数组的长度。空间复杂度主要取决于图的大小和队列的大小，保存有向图信息所需空间为 O(n+m)，由于每层遍历最多有 O(n)个分支，因此遍历到 k 层时，队列的大小为 O(n^k^)

