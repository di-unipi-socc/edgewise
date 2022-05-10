import parse as p

COMP1 = "service({id}, {type}, [{swreqs}], ({arch}, {hwreqs}))."
COMP2 = "function({id}, {type}, {swreqs}, ({arch}, {hwreqs}))."
THING = "thing({id}, {type})."

SERVICE_INSTANCE = "serviceInstance({id}, {service})."
FUNCTION_INSTANCE = "functionInstance({id}, {function} ({req_x_month}, {req_duration}))."
THING_INSTANCE = "thingInstance({id}, {thing_id})."

DATA_FLOW = "dataFlow({source}, {target}, {data_type}, [{secreqs}], {size}, {rate}, {max_latency})."


class Component:
	is_service = True

	def __init__(self, id, type, swreqs, arch, hwreqs):
		self.id = id
		self.type = type
		self.swreqs = swreqs
		self.arch = arch
		self.hwreqs = float(hwreqs)

	@classmethod
	def parse(cls, data):
		out = p.parse(COMP1, data)  # try service
		if not out:
			out = p.parse(COMP2, data)  # try function
			# self.is_service = False
			if not out:
				raise ParseException("{} parse error".format(cls.__class__))

		return out.named

	def __str__(self):
		if self.is_service:
			return COMP1.format(**self.__dict__)
		else:
			return COMP2.format(**self.__dict__)


class ServiceInstance:
	def __init__(self, id, service: Component):
		self.id = id
		self.service = service
		self.node = None

	def __str__(self):
		return SERVICE_INSTANCE.format(**self.__dict__)

	def set_node(self, node):
		self.node = node

	@classmethod
	def parse(cls, data):
		out = p.parse(SERVICE_INSTANCE, data)
		if not out:
			raise ParseException("{} parse error".format(cls.__class__))

		return out.named


class FunctionInstance:
	def __init__(self, id, function: Component, req_x_month, req_duration):
		self.id = id
		self.function = function
		self.req_x_month = float(req_x_month)
		self.req_duration = float(req_duration)
		self.node = None

	def __str__(self):
		return FUNCTION_INSTANCE.format(**self.__dict__)

	def set_node(self, node):
		self.node = node

	@classmethod
	def parse(cls, data):
		out = p.parse(FUNCTION_INSTANCE, data)
		if not out:
			raise ParseException("{} parse error".format(cls.__class__))

		return out.named


""" THING (IoT device) """


class Thing:
	def __init__(self, id, type):
		self.id = id
		self.type = type

	def __str__(self):
		return THING.format(**self.__dict__)

	@classmethod
	def parse(cls, data):
		out = p.parse(THING, data)
		if not out:
			raise ParseException("{} parse error".format(cls.__class__))

		return out.named


class ThingInstance:
	def __init__(self, id, thing_id: Thing):
		self.id = id
		self.thing_id = thing_id
		self.node = None

	def __str__(self):
		return THING_INSTANCE.format(**self.__dict__)

	def set_node(self, node):
		self.node = node

	@classmethod
	def parse(cls, data):
		out = p.parse(THING_INSTANCE, data)
		if not out:
			raise ParseException("{} parse error".format(cls.__class__))

		return out.named


""" DATAFLOW: interaction between two components"""


class DataFlow:
	def __init__(self, source, target, data_type, secreqs, size, rate, max_latency):
		self.source = source
		self.target = target
		self.data_type = data_type
		self.secreqs = secreqs
		self.size = float(size)
		self.rate = float(rate)
		self.max_latency = float(max_latency)

		self.reqbw = self.rate * self.size

	@classmethod
	def parse(cls, data):
		out = p.parse(DATA_FLOW, data)
		if not out:
			raise ParseException("{} parse error".format(cls.__class__))

		return out.named

	def __str__(self):
		data = self.__dict__
		data['source'] = self.source.id
		data['target'] = self.target.id
		return DATA_FLOW.format(**data)


class ParseException(Exception):
	def __init__(self, message):
		self.message = message


if __name__ == "__main__":
	pass