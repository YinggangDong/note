# Set的add方法引起的数据丢失
## 问题现象
问题代码
```java
        Set<InboundVO> inboundSet = new HashSet<>();
        //将redis中的数据转换为InboundVO对象
        for (String inbound : inboundRedisSet) {
            InboundVO inboundVO = JSONUtil.toBean(inbound, InboundVO.class);
            inboundSet.add(inboundVO);
        }
```
涉及对象类有两个分别是入库对象类(InboundVO)和出库对象类(OutboundVO)。

两者存在继承关系，InboundVO继承OutboundVO，InboundVO多了两个属性 damage 和 damageImageList，详细代码如下：
```java
/**
 * 入库记录对象
 *
 * @author dongyinggang
 * @date 2023/5/16 18:56
 */
@Data
@ApiModel(description = "入库记录对象")
@EqualsAndHashCode(callSuper = true)
public class InboundVO extends OutboundVO {

    /**
     * 是否货损
     */
    @ApiModelProperty(value = "是否货损", example = "true")
    private Boolean damage;

    /**
     * 货损图片
     */
    @ApiModelProperty(value = "货损图片", example = "[\"https://XXX.XXX.info/alioss/b.jpg\",\"https://XXXX.XXX.info/alioss/a.jpg\"]")
    private String damageImageList;

    /**
     * 获取资产的状态
     *
     * @return {@link String }
     * @author dongyinggang
     * @date 2023/6/6 16:29
     **/
    public String generateAssetState() {
        if (Boolean.TRUE.equals(damage)) {
            return AssetStatusEnum.DAMAGED.getDesc();
        } else {
            return AssetStatusEnum.NORMAL.getDesc();
        }
    }

    /**
     * 合并货损图片和异常图片
     *
     * @return {@link String }
     * @author dongyinggang
     * @date 2023/6/7 13:07
     **/
    public String generateAllPicUrl() {
        StringBuilder allPicUrl = new StringBuilder();
        if (getAbnormalImageList() != null) {
            allPicUrl.append(getAbnormalImageList()).append(",");
        }
        if (getDamageImageList() != null) {
            allPicUrl.append(getDamageImageList());
        }
        return allPicUrl.toString();
    }

}
```

```java
/**
 * 出库记录对象
 *
 * @author dongyinggang
 * @date 2023/5/16 18:49
 */
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@ApiModel(description = "出库清单条目对象")
public class OutboundVO {

    /**
     * 资产编码
     */
    @ApiModelProperty(value = "资产编码", example = "ASSET123456")
    private String assetCode;

    /**
     * 客户编码
     */
    @ApiModelProperty(value = "客户编码", example = "FC")
    private String customerCode;

    /**
     * 客户名称
     */
    @ApiModelProperty(value = "客户名称", example = "丰巢")
    private String customerName;

    /**
     * 产品名称
     */
    @ApiModelProperty(value = "产品名称", example = "顺丰A柜")
    private String productName;

    /**
     * 异常原因（编码在其他区仓，编码无关联设备）
     */
    @ApiModelProperty(value = "异常原因（编码在其他区仓，编码无关联设备）", example = "编码无关联设备")
    private String abnormalReason;

    /**
     * 异常图片列表 | 设备图片列表
     */
    @ApiModelProperty(value = "异常图片列表", example =
            "[\"https://XXXX.XXXX.info/alioss/b.jpg\",\"https://XXXX.XXXX.info/alioss/a.jpg\"]")
    private String abnormalImageList;

    /**
     * 备注
     */
    @ApiModelProperty(value = "备注", example = "备注")
    private String remark;

    /**
     * 资产类型：新机、旧机、撤机、暂存
     */
    @ApiModelProperty(value = "资产类型：新机、旧机、撤机、暂存", example = "新机")
    private String assetType;

    /**
     * 资产状态
     */
    @ApiModelProperty(value = "资产状态")
    private String assetState;
}

```
以上代码，通过 inboundRedisSet 转化为 inboundSet 的过程中，出现了丢失，经排查，定位到问题是 `inboundSet.add(inboundVO);` 时，add 方法判断是否 inboundSet 是否存在时，由于InboundVO 仅有两个属性属于自己，其他均属于父类 OutboudnVO，仅判断了两个属性是否相等，由于数据中存在部分对象的这两个属性是一致的，导致向Set 中 add 时覆盖了之前的数据，导致数据丢失。

通过在子类 InboundVO 中增加注解 `@EqualsAndHashCode(callSuper = true)`，解决了问题。使用该注解后，Lombok生成的equals和hashCode方法会调用父类的equals和hashCode方法，从而实现了对父类属性的比较。
