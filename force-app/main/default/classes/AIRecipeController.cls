public with sharing class AIRecipeController {

    @AuraEnabled
    public static String generateAIRecipes(String ingredients, String dietaryRestrictions, String mealType, String servings) {
        try {
            Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();

            ConnectApi.WrappedValue ingredientsValue = new ConnectApi.WrappedValue();
            ingredientsValue.value = ingredients;

            ConnectApi.WrappedValue dietaryRestrictionsValue = new ConnectApi.WrappedValue();
            dietaryRestrictionsValue.value = dietaryRestrictions;

            ConnectApi.WrappedValue mealTypeValue = new ConnectApi.WrappedValue();
            mealTypeValue.value = mealType;

            ConnectApi.WrappedValue servingsValue = new ConnectApi.WrappedValue();
            servingsValue.value = servings;

            inputParams.put('Input:Ingredients', ingredientsValue);
            inputParams.put('Input:Dietary_Restrictions', dietaryRestrictionsValue);
            inputParams.put('Input:Meal_Type', mealTypeValue);
            inputParams.put('Input:Serving_Size', servingsValue);

            if (UserInfo.getUserType() == 'Guest') {
                return '{"recipes":[{"recipe_name":"Garlic Chicken Pasta","description":"A simple and flavorful dish combining tender chicken and pasta with a rich garlic sauce.","prep_time":"10","cook_time":"15","total_time":"25","difficulty":"Easy","servings":"2","ingredients":[{"amount":"200","unit":"grams","name":"chicken breast"},{"amount":"150","unit":"grams","name":"pasta"},{"amount":"4","unit":"cloves","name":"garlic"},{"amount":"2","unit":"tablespoons","name":"olive oil"}],"instructions":["Cook pasta according to package instructions.","Saute garlic in olive oil.","Cook chicken until golden.","Mix with pasta and serve."],"tips":"Serve with grated Parmesan cheese for added flavor.","tags":["chicken","pasta","lunch"]},{"recipe_name":"Creamy Garlic Chicken Pasta","description":"A rich and creamy pasta dish featuring sauteed chicken and garlic in a creamy sauce.","prep_time":"10","cook_time":"15","total_time":"25","difficulty":"Medium","servings":"2","ingredients":[{"amount":"200","unit":"grams","name":"chicken breast"},{"amount":"150","unit":"grams","name":"pasta"},{"amount":"1","unit":"cup","name":"cream"}],"instructions":["Cook pasta.","Cook chicken with garlic.","Add cream.","Combine and serve."],"tips":"Garnish with parsley.","tags":["chicken","pasta","creamy"]},{"recipe_name":"Garlic Chicken Pasta Salad","description":"A refreshing pasta salad with grilled chicken and garlic vinaigrette.","prep_time":"15","cook_time":"10","total_time":"25","difficulty":"Easy","servings":"2","ingredients":[{"amount":"200","unit":"grams","name":"chicken breast"},{"amount":"150","unit":"grams","name":"pasta"},{"amount":"3","unit":"cloves","name":"garlic"}],"instructions":["Cook pasta.","Cook chicken.","Combine ingredients and serve chilled."],"tips":"Serve chilled or at room temperature.","tags":["chicken","pasta","salad"]}]}';
            }

            ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
            executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
            executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
            executeTemplateInput.isPreview = false;
            executeTemplateInput.inputParams = inputParams;

            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput =
                ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate('Recipe_Generator', executeTemplateInput);

            ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
            return response.text;

        } catch (Exception e) {
            throw new AuraHandledException('Error generating recipes: ' + e.getMessage());
        }
    }
}