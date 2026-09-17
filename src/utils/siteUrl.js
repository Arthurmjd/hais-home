// 站点域名拆分工具：返回 [主段, 后缀段, ...]，供 Logo 大字/小字拼接使用
export const getSiteUrlParts = () => {
  const raw = import.meta.env.VITE_SITE_URL || "";
  const url = raw.replace(/^(https?:\/\/)/, "");
  if (url) return url.split(".");
  // 未配置站点地址时，用站点名称兜底
  return [import.meta.env.VITE_SITE_NAME || "Home"];
};
