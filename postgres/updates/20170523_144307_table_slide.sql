-- ALTER TABLE public.system_settings ADD COLUMN type text;
ALTER TABLE public.system_settings ADD COLUMN explain text;
INSERT INTO public.system_settings(key, value,type,explain)
	VALUES ('app_name', 'Vivu','system','App name');