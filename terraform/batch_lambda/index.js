const AWS = require('aws-sdk');
const uuid = require('uuid/v4');
const crypto = require('crypto-js');

exports.handler = (event, context, callback) => {
  AWS.config.region = context.invokedFunctionArn.match(/^arn:aws:lambda:(\w+-\w+-\d+):/)[1];

  var bucket = event.Records[0].s3.bucket.name
  var key = event.Records[0].s3.object.key

  var message = {
    job_class: process.env.JobClassName,
    job_id: uuid(),
    provider_job_id: null,
    queue_name: process.env.QueueName,
    arguments: [bucket, key],
    executions: 0,
    locale: "en"
  }

  var sqs = new AWS.SQS();
  var body = JSON.stringify(message);
  var digest = crypto.HmacSHA1(body,process.env.Secret).toString();
  var params = {
    MessageBody: body,
    QueueUrl: process.env.QueueUrl,
    MessageAttributes: {
      "shoryuken_class": { DataType: "String", StringValue: "ActiveJob::QueueAdapters::ShoryukenAdapter::JobWrapper" },
      "message-digest": { DataType: "String", StringValue: digest }
    }
  };
  sqs.sendMessage(params, callback);
}
