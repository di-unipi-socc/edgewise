from os.path import dirname, abspath, join, exists
from .components import *
from scripts.utils import check_app


class Application:
	def __init__(self, app_name):
		self.id = app_name
		self.components = []
		self.services = []
		self.functions = []
		self.things = []
		self.things_instances = []
		self.data_flows = []

		self.parse(app_name)

	def parse(self, app_name):
		app_file = check_app(app_name)

		with open(app_file, "r") as f:
			lines = f.read().splitlines()

			services = [i for i in lines if i.startswith("service(")]
			functions = [i for i in lines if i.startswith("function(")]
			things = [i for i in lines if i.startswith("thing(")]
			service_instances = [i for i in lines if i.startswith("serviceInstance(")]
			function_instances = [i for i in lines if i.startswith("functionInstance(")]
			thing_instances = [i for i in lines if i.startswith("thingInstance(")]

			data_flows = [i for i in lines if i.startswith("dataFlow(")]

			self.add_components(services)
			self.add_components(functions)
			self.add_things(things)
			self.add_services(service_instances)
			self.add_functions(function_instances)
			self.add_thing_instances(thing_instances)
			self.add_data_flows(data_flows)

	def add_component(self, component: Component):
		self.components.append(component)

	def add_components(self, components):
		for c in components:
			data = Component.parse(c)
			self.add_component(Component(**data))

	def add_service(self, service: ServiceInstance):
		self.services.append(service)

	def add_services(self, services):
		for s in services:
			data = ServiceInstance.parse(s)
			self.add_service(ServiceInstance(**data))

	def add_function(self, function: FunctionInstance):
		self.functions.append(function)

	def add_functions(self, functions):
		for f in functions:
			data = FunctionInstance.parse(f)
			self.add_function(FunctionInstance(**data))

	def add_thing(self, thing: Thing):
		self.things.append(thing)

	def add_things(self, things):
		for t in things:
			data = Thing.parse(t)
			self.add_thing(Thing(**data))

	def add_thing_instance(self, thing_instance: ThingInstance):
		self.things_instances.append(thing_instance)

	def add_thing_instances(self, thing_instances):
		for ti in thing_instances:
			data = ThingInstance.parse(ti)
			self.add_thing_instance(ThingInstance(**data))

	def add_data_flow(self, data_flow: DataFlow):
		self.data_flows.append(data_flow)

	def add_data_flows(self, data_flows):
		for df in data_flows:
			d = DataFlow.parse(df)
			d['source'] = self.get_instance_by_id(d['source'])
			d['target'] = self.get_instance_by_id(d['target'])
			self.add_data_flow(DataFlow(**d))

	def get_component_by_id(self, component_id):
		return next((c for c in self.components if c.id == component_id), None)

	def get_instance_by_id(self, instance_id):
		instance = next((i for i in self.things_instances if i.id == instance_id), None)  # thing instance
		if not instance:
			instance = next((i for i in self.services if i.id == instance_id), None)  # service instance
		if not instance:
			instance = next((i for i in self.functions if i.id == instance_id), None)  # function instance
		if not instance:
			raise Exception(f'Instance with id {instance_id} not found')

		return instance

	def get_service_by_id(self, service_id):
		return next((s for s in self.services if s.id == service_id), None)

	def get_function_by_id(self, function_id):
		return next((f for f in self.functions if f.id == function_id), None)

	def get_thing_by_id(self, thing_id):
		return next((t for t in self.things_instances if t.id == thing_id), None)

	def get_component_data_flow(self, component_id):
		return [df for df in self.data_flows if df.source.id == component_id or df.target.id == component_id]

	def __str__(self):
		str_app = f"Application {self.id}:\n"
		for c in self.components:
			str_app += f'{c}\n'
		str_app += '\n'
		for s in self.services:
			str_app += f'{s}\n'
		str_app += '\n'
		for f in self.functions:
			str_app += f'{f}\n'
		str_app += '\n'
		for t in self.things:
			str_app += f'{t}\n'
		str_app += '\n'
		for df in self.data_flows:
			str_app += f'{df}\n'

		return str_app


