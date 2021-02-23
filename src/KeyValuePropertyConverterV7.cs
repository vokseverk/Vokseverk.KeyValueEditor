using Umbraco.Core.Models.PublishedContent;
using Umbraco.Core.PropertyEditors;

namespace Vokseverk {

	[PropertyValueType(typeof(IEnumerable<Dictionary<string, string>>))]
	[PropertyValueCache(PropertyCacheValue.All, PropertyCacheLevel.Content)]
	public class KeyValuePropertyConverter : PropertyValueConverterBase {

		public override bool IsConverter(PublishedPropertyType propertyType) {
			return propertyType.PropertyEditorAlias.Equals("Vokseverk.PropertyEditors.KeyValueEditor");
		}

		public override object ConvertSourceToObject(PublishedPropertyType propertyType, object source, bool preview) {
			if (source == null) return IEnumerable.Empty();
			
			var value = new Dictionary<string, string>();
			
			foreach (var pair in source) {
				value.Add(source["key"], source["value"]);
			}
			
			return value;
		}
	}
}
