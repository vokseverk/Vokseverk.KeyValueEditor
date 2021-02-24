using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Umbraco.Core;
using Umbraco.Core.PropertyEditors;
using Umbraco.Core.Models.PublishedContent;

namespace Vokseverk {

	[PropertyValueType(typeof(List<KeyValuePair<string, string>>))]
	[PropertyValueCache(PropertyCacheValue.All, PropertyCacheLevel.Content)]
	public class KeyValuePropertyConverter : PropertyValueConverterBase {

		public override bool IsConverter(PublishedPropertyType propertyType) {
			return propertyType.PropertyEditorAlias.Equals("Vokseverk.KeyValueEditor");
		}
		
		public override object ConvertDataToSource(PublishedPropertyType propertyType, object data, bool preview) {
			var list = new List<KeyValuePair<string, string>>();
			if (data == null) {
				return list;
			}
			
			var source = data.ToString();
			if (source.DetectIsJson()) {
				try {
					var json = JsonConvert.DeserializeObject<JArray>(source);
					
					foreach (var jt in json) {
						var kvp = new KeyValuePair<string, string>(jt["key"].ToString(), jt["value"].ToString());
						list.Add(kvp);
					}
					return list;
				}
				catch { /* Hmm, not JSON after all ... */ }
			}
			
			return list;
		}
	}
}
