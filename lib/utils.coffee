module.exports.mergeDefault = (option, defaultOption)->
  temp = {}

  for key, value of defaultOption
    temp[key] = value

  for key, value of option
    temp[key] = value
  
  temp

