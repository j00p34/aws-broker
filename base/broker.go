package base

import (
	"github.com/cloudfoundry-community/aws-broker/catalog"
	"github.com/cloudfoundry-community/aws-broker/helpers/request"
	"github.com/cloudfoundry-community/aws-broker/helpers/response"
)

type Broker interface {
	CreateInstance(*catalog.Catalog, string, request.CreateRequest) response.Response
	BindInstance(*catalog.Catalog, string, request.BindRequest) response.Response
	DeleteInstance(*catalog.Catalog, string, request.DeleteRequest) response.Response
}
