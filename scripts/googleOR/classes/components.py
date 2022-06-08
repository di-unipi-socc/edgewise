import parse as p

COMP1 = "service({id}, {type}, [{swreqs:to_list}], ({arch}, {hwreqs:g}))."
COMP2 = "function({id}, {type}, {swreqs}, ({arch}, {hwreqs:g}))."
THING = "thing({id}, {type})."

SERVICE_INSTANCE = "serviceInstance({id}, {comp})."
FUNCTION_INSTANCE = "functionInstance({id}, {comp}, ({req_x_month:g}, {req_duration:g}))."
THING_INSTANCE = "thingInstance({id}, {thing})."

DATA_FLOW = "dataFlow({source}, {target}, {data_type}, [{secreqs:to_list}], {size:g}, {rate:g}, {latency:g})."


def to_list(s):
	return s.split(',') if s else []


class Component:
	is_service = True

	def __init__(self, id, type, swreqs, arch, hwreqs):
		self.id = id
		self.type = type
		self.swreqs = swreqs
		self.arch = arch
		self.hwreqs = hwreqs

	@classmethod
	def parse(cls, data):
		out = p.parse(COMP1, data, dict(to_list=to_list))  # try service
		if not out:
			out = p.parse(COMP2, data)  # try function
			# self.is_service = False
			if not out:
				raise ParseException("{} parse error".format(cls.__class__))

		return out.named

	def __str__(self):
		if self.is_service:
			return "service({id}, {type}, {swreqs}, ({arch}, {hwreqs})).".format(**self.__dict__)
		else:
			return "function({id}, {type}, {swreqs}, ({arch}, {hwreqs})).".format(**self.__dict__)


class ServiceInstance:
	def __init__(self, id, comp: Component):
		self.id = id
		self.comp = comp
		self.compatibles = []

	def __str__(self):
		data = self.__dict__.copy()
		data['comp'] = data['comp'].id
		return SERVICE_INSTANCE.format(**data)

	def set_compatibles(self, compatibles):
		self.compatibles = compatibles

	@classmethod
	def parse(cls, data):
		out = p.parse(SERVICE_INSTANCE, data)
		if not out:
			raise ParseException("{} parse error".format(cls.__class__))
		return out.named


class FunctionInstance:
	def __init__(self, id, comp: Component, req_x_month, req_duration):
		self.id = id
		self.comp = comp
		self.req_x_month = req_x_month
		self.req_duration = req_duration
		self.compatibles = []

	def __str__(self):
		data = self.__dict__.copy()
		data['comp'] = data['comp'].id
		return FUNCTION_INSTANCE.format(**data)

	def set_compatibles(self, compatibles):
		self.compatibles = compatibles

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
	def __init__(self, id, thing: Thing):
		self.id = id
		self.thing = thing
		self.node = None

	def __str__(self):
		data = self.__dict__.copy()
		data['thing'] = data['thing'].id
		return THING_INSTANCE.format(**data)

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
	def __init__(self, source, target, data_type, secreqs, size, rate, latency):
		self.source = source
		self.target = target
		self.data_type = data_type
		self.secreqs = secreqs
		self.size = size
		self.rate = rate
		self.latency = latency

		self.bw = self.rate * self.size

	@classmethod
	def parse(cls, data):
		out = p.parse(DATA_FLOW, data, dict(to_list=to_list))
		if not out:
			raise ParseException("{} parse error".format(cls.__class__))

		return out.named

	def __str__(self):
		data = self.__dict__.copy()
		data['source'] = self.source.id
		data['target'] = self.target.id

		return "dataFlow({source}, {target}, {data_type}, {secreqs}, {size}, {rate}, {latency}).".format(**data)


class ParseException(Exception):
	def __init__(self, message):
		self.message = message
