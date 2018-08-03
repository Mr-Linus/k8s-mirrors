from aliyunsdkcore import client
from aliyunsdkcr.request.v20160607 import GetImageLayerRequest
import optparse


def main():
    parser = optparse.OptionParser('usage: check-tags.py -i <access id> -k <access key> -n <repo name> -t <repo tag> -s <repo namespace>')
    parser.add_option('-i', dest='id', type='string', help='specify access id')
    parser.add_option('-k', dest='key', type='string', help='specify access key')
    parser.add_option('-n', dest='name', type='string', help='specify repo name')
    parser.add_option('-t', dest='tag', type='string', help='specify repo tag')
    parser.add_option('-s', dest='space', type='string', help='specify repo namespace')
    (options, args) = parser.parse_args()
    if (options.id == None) or (options.key == None) or (options.name == None) or (options.tag == None) or (options.space == None):
        print(parser.usage)
        exit(1)
    else:
        client.region_provider.add_endpoint("cr", "cn-hangzhou", "cr.cn-hangzhou.aliyuncs.com")
        apiClient = client.AcsClient(options.id, options.key, 'cn-hangzhou')
        request = GetImageLayerRequest.GetImageLayerRequest()
        request.set_RepoName(options.name)
        request.set_RepoNamespace(options.space)
        request.set_Tag(options.tag)
        response = eval(apiClient.do_action(request).decode('utf-8'))
        if response['data']['image'] == {}:
            print("This tag does not exist.")
            exit(0)
        else:
            exit(1)


if __name__ == '__main__':
    main()