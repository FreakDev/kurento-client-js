<#include "macros.ftm" >
<#assign module_name=module.name>
<#assign module_namespace>
  <#lt>${module_name}/complexTypes<#rt>
</#assign>
<#assign complexType_namepath>
  <#lt>${module_namespace}.${complexType.name}<#rt>
</#assign>
<#if complexType.extends??>
  <#assign extends_name>
    <#lt>${complexType.extends.name}<#rt>
  </#assign>
  <#assign import_name=''>
  <#list module.imports as import>
    <#list import.module.complexTypes as complexType>
      <#if complexType.name == extends_name>
        <#assign import_name=import.name>
        <#break>
      </#if>
    </#list>
    <#if import_name != ''>
      <#break>
    </#if>
  </#list>
  <#if import_name == ''>
    <#list module.complexTypes as complexType>
      <#if complexType.name == extends_name>
        <#assign import_name=module_name>
        <#break>
      </#if>
    </#list>
  </#if>
</#if>
complexTypes/${complexType.name}.js
/* Autogenerated with Kurento Idl */

<#include "license.ftm" >

<#if complexType.extends??>
var inherits = require('inherits');

</#if>
var kurentoClient = require('kurento-client');

<#if complexType.typeFormat == "REGISTER">
var checkType = kurentoClient.checkType;
var ChecktypeError = checkType.ChecktypeError;
</#if>
<#if complexType.extends??>
  <#assign import_package="">
  <#list module.imports as import>
    <#list import.module.complexTypes as complexType>
      <#if complexType.name == extends_name>
        <#assign import_package=import.module.code.api.js.nodeName>
        <#break>
      </#if>
    </#list>
    <#if import_package != "">
      <#break>
    </#if>
  </#list>

  <#if import_name == module_name>
var ${extends_name} = require('./${extends_name}');
  <#elseif module_name=='core'
        || module_name=='elements'
        || module_name=='filters'>
var ${extends_name} = require('${import_package}').${extends_name};
  <#else>
var ${extends_name} = kurentoClient.register.complexTypes.${extends_name};
  </#if>
</#if>


/**
<#if complexType.doc??>
  <@docstring doc=complexType.doc namepath=complexType_namepath/>
 *
</#if>
<#switch complexType.typeFormat>
  <#case "ENUM">
 * @typedef ${complexType_namepath}
 *
 * @type {(<@join sequence=complexType.values separator="|"/>)}
  <#break>
  <#case "REGISTER">
 * @constructor module:${complexType_namepath}
 *
    <#list complexType.properties as property>
 * @property {${namepath(property.type.name)}} ${property.name}
      <@docstring doc=property.doc namepath=complexType_namepath indent=1/>
    </#list>
    <#if complexType.extends??>

 * @extends module:${import_name}.${extends_name}
    </#if>
  <#break>
</#switch>
 */
<#if complexType.typeFormat == "REGISTER">
  <#assign complexTypeDict=complexType.name?uncap_first+"Dict">
function ${complexType.name}(${complexTypeDict}){
  if(!(this instanceof ${complexType.name}))
    return new ${complexType.name}(${complexTypeDict})
  <#if complexType.properties??>

  // Check ${complexTypeDict} has the required fields
    <#list complexType.properties as property>
  checkType('${property.type.name}', '${complexTypeDict}.${property.name}', ${complexTypeDict}.${property.name}${property.optional?string("", ", true")});
    </#list>
  </#if>
  <#if complexType.extends??>

  // Init parent class
  ${complexType.name}.super_.call(this, ${complexTypeDict})
  </#if>
  <#if complexType.properties??>

  // Set object properties
  Object.defineProperties(this, {
    <#list complexType.properties as property>
    ${property.name}: {
      <#if !(property.final || property.readOnly)>
      writable: true,
      </#if>
      enumerable: true,
      value: ${complexTypeDict}.${property.name}
    }<#if property_has_next>,</#if>
    </#list>
  })
  </#if>
}
  <#if complexType.extends??>
inherits(${complexType.name}, ${extends_name})
  </#if>
</#if>

/**
 * Checker for {@link ${complexType_namepath}}
 *
 * @memberof module:${module_namespace}
 *
 * @param {external:String} key
 * @param {module:${complexType_namepath}} value
 */
function check${complexType.name}(key, value)
{
<#switch complexType.typeFormat>
  <#case "ENUM">
  if(typeof value != 'string')
    throw SyntaxError(key+' param should be a String, not '+typeof value);

  if(!value.match('<@join sequence=complexType.values separator="|"/>'))
    throw SyntaxError(key+' param is not one of [<@join sequence=complexType.values separator="|"/>] ('+value+')');
  <#break>
  <#case "REGISTER">
  if(!(value instanceof ${complexType.name}))
    throw ChecktypeError(key, ${complexType.name}, value);
  <#break>
</#switch>
};


<#switch complexType.typeFormat>
  <#case "ENUM">
module.exports = check${complexType.name};
  <#break>
  <#case "REGISTER">
module.exports = ${complexType.name};

${complexType.name}.check = check${complexType.name};
  <#break>
</#switch>
