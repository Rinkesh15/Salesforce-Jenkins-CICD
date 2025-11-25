/**
* @File Name : CICDJenkins.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : November 25, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 25, 2025 |   | Initial Version
**/

public class CICDJenkins {
	@AuraEnabled
	 public static String sayHello() {
        String msg = 'Hello';
        System.debug('HelloWorld.sayHello -> ' + msg);
        return msg;
    }
}