public class OpportunityMetadata {
    public static String getOpportunityMetadataXML() {
        String objectName = 'Opportunity';

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType opportunitySchema = schemaMap.get(objectName);
        if (opportunitySchema != null) {
            Schema.DescribeSObjectResult describeResult = opportunitySchema.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = describeResult.fields.getMap();

            // Create a list to store field metadata as maps
            List<Map<String, String>> fieldList = new List<Map<String, String>>();

            // Loop through the fields and add them to the list as maps
            for (String fieldName : fieldsMap.keySet()) {
                Schema.SObjectField field = fieldsMap.get(fieldName);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

                Map<String, String> fieldMap = new Map<String, String>();
                fieldMap.put('Name', fieldDescribe.getName());
                fieldMap.put('Type', String.valueOf(fieldDescribe.getType()));
                fieldMap.put('Label', fieldDescribe.getLabel());
                fieldMap.put('Length', String.valueOf(fieldDescribe.getLength()));
                fieldMap.put('Precision', String.valueOf(fieldDescribe.getPrecision()));
                // Add more attributes as needed

                fieldList.add(fieldMap);
            }

            // Convert the fieldList to JSON
            String jsonMetadata = JSON.serializePretty(fieldList);

            // Wrap the JSON in XML tags
            String xmlMetadata = '<OpportunityMetadata>';
            xmlMetadata += jsonMetadata;
            xmlMetadata += '</OpportunityMetadata>';

            return xmlMetadata;
        }

        // Return an empty string if the Opportunity object is not found
        return '';
    }
}