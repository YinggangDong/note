# 剑指 Offer 40. 最小的k个数

[剑指 Offer 40. 最小的k个数](https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof/)

## 代码

1.通过大根堆获取最小的k个数

```java
class Solution {
    public int[] getLeastNumbers(int[] arr, int k) {
        
        if(arr.length==0||k==0){
            return new int[0];
        }
        //默认是小根堆，这里需要一个大根堆,把所有大于根的元素排除掉,最后剩下k个元素
        Queue<Integer> maxHeap = new PriorityQueue<>(k,(o1,o2)->o2.compareTo(o1));
        for(int i=0;i<arr.length;i++){
            //如果堆的大小没到k,则向其中写入元素
            if(maxHeap.size()<k){
                maxHeap.offer(arr[i]);
            }else if(maxHeap.peek()>arr[i]){
                //当堆达到了k个元素,每个新元素都和堆顶元素比较，若大于堆顶元素，则不进堆，否则将堆顶元素出堆，当前元素入堆
                maxHeap.poll();
                maxHeap.offer(arr[i]);
            }
        }
        int[] res = new int[maxHeap.size()];
        int index =0;
        while(maxHeap.peek()!=null){
            res[index++]=maxHeap.poll();
        }
        return res;
    }
}
```

