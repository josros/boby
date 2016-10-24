# Boby Example

Here you can see a more complex boby example. Imagine we have an entity "Person" in a strict three layer architecture based java project (e.g. as demonstrated [here](https://github.com/josros/springbootstrap)). One could define the data of it's layers as shown below:

## What you define:
 
	
	import de.jro.demo.db.data.AbstractEntity
	import javax.persistence.Column
	import javax.persistence.Entity
	import javax.validation.constraints.Min
	import javax.validation.constraints.NotNull
	
	package de.jro.example {
		
		package persistence {
			
			@Entity(name = "Person")
			boby PersonEntity extends AbstractEntity {
				@Column(name = "name")
				name: String
				@Column(name = "age")
				age: Integer
			}
			
			generic builder GenericPersonEntityBuilder for PersonEntity
			build builder PersonEntityBuilder extends GenericPersonEntityBuilder
			
		}
	
		package business {
			
			boby immutable PersonVO {
				id: Long
				name: String
				age: Integer
			}
			
			generic builder GenericPersonVOBuilder for PersonVO
			build builder PersonVOBuilder extends GenericPersonVOBuilder
			
		}
	
		package rest {
			
			boby PersonDTO {
				@NotNull(message = "name must be set.")
				name: String
				@Min(value = 0)
				age: Integer
			}
			
			boby PersonIdDTO extends PersonDTO {
				id: Long
			}
			
			generic builder GenericPersonIdDTOBuilder for PersonIdDTO
			build builder PersonIdDTOBuilder extends GenericPersonIdDTOBuilder
		}
	
	}
	
	package de.jro.example.test {
		
		package persistence {
			mock builder PersonEntityMocker extends de.jro.example.persistence.GenericPersonEntityBuilder
		}
		
		package business {
			mock builder PersonVOMocker extends de.jro.example.business.GenericPersonVOBuilder
		}
		
		package rest {
			mock builder PersonIdDTOMocker extends de.jro.example.rest.GenericPersonIdDTOBuilder
		}
	
	}

_example.boby_

If you are working in a boby project, eclipse generates the following files for you. Remember that for the `mock builder` it is required to have *Mockito* on the classpath.

## What boby generates:

	package de.jro.example.persistence;
	
	import de.jro.demo.db.data.AbstractEntity;
	import javax.persistence.Column;
	import javax.persistence.Entity;
	
	@Entity(name = "Person")
	@SuppressWarnings("all")
	public class PersonEntity extends AbstractEntity {
	  @Column(name = "name")
	  private String name;
	  
	  @Column(name = "age")
	  private Integer age;
	  
	  public String getName() {
	    return this.name;
	  }
	  
	  public void setName(final String name) {
	    this.name = name;
	  }
	  
	  public Integer getAge() {
	    return this.age;
	  }
	  
	  public void setAge(final Integer age) {
	    this.age = age;
	  }
	}

src-gen/_de.jro.example.persistence.PersonEntity.java_

	package de.jro.example.persistence;
	
	import java.util.Date;
	
	@SuppressWarnings("all")
	public class GenericPersonEntityBuilder<B extends GenericPersonEntityBuilder<B>> {
	  protected boolean deleted;
	  protected long id;
	  protected Date lastUpdateDate;
	  protected String name;
	  protected Integer age;
	  
	  @SuppressWarnings("unchecked")
	  public B deleted(boolean deleted) {
	    this.deleted = deleted;
	    return (B) this;
	  }
	  @SuppressWarnings("unchecked")
	  public B id(long id) {
	    this.id = id;
	    return (B) this;
	  }
	  @SuppressWarnings("unchecked")
	  public B lastUpdateDate(Date lastUpdateDate) {
	    this.lastUpdateDate = lastUpdateDate;
	    return (B) this;
	  }
	  @SuppressWarnings("unchecked")
	  public B name(String name) {
	    this.name = name;
	    return (B) this;
	  }
	  
	  @SuppressWarnings("unchecked")
	  public B age(Integer age) {
	    this.age = age;
	    return (B) this;
	  }
	}

src-gen/_de.jro.example.persistence.GenericPersonEntityBuilder.java_

	package de.jro.example.persistence;
	
	
	@SuppressWarnings("all")
	public class PersonEntityBuilder extends de.jro.example.persistence.GenericPersonEntityBuilder<PersonEntityBuilder> {
	  public de.jro.example.persistence.PersonEntity build() {
	    de.jro.example.persistence.PersonEntity obj = new de.jro.example.persistence.PersonEntity();
	    obj.setDeleted(deleted);
	    obj.setId(id);
	    obj.setLastUpdateDate(lastUpdateDate);
	    obj.setName(name);
	    obj.setAge(age);
	    return obj;
	  }
	}

src-gen/_de.jro.example.persistence.PersonEntityBuilder.java_

	package de.jro.example.business;
	
	@SuppressWarnings("all")
	public class PersonVO {
	  private final Long id;
	  
	  private final String name;
	  
	  private final Integer age;
	  
	  public PersonVO(final Long id, final String name, final Integer age) {
	    this.id = id;
	    this.name = name;
	    this.age = age;
	  }
	  
	  public Long getId() {
	    return this.id;
	  }
	  
	  public String getName() {
	    return this.name;
	  }
	  
	  public Integer getAge() {
	    return this.age;
	  }
	}
	
src-gen/_de.jro.example.business.PersonVO.java_

	package de.jro.example.business;
	
	
	@SuppressWarnings("all")
	public class GenericPersonVOBuilder<B extends GenericPersonVOBuilder<B>> {
	  protected Long id;
	  protected String name;
	  protected Integer age;
	  
	  @SuppressWarnings("unchecked")
	  public B id(Long id) {
	    this.id = id;
	    return (B) this;
	  }
	  
	  @SuppressWarnings("unchecked")
	  public B name(String name) {
	    this.name = name;
	    return (B) this;
	  }
	  
	  @SuppressWarnings("unchecked")
	  public B age(Integer age) {
	    this.age = age;
	    return (B) this;
	  }
	}

src-gen/_de.jro.example.business.GenericPersonVOBuilder.java_


	package de.jro.example.business;
	
	
	@SuppressWarnings("all")
	public class PersonVOBuilder extends de.jro.example.business.GenericPersonVOBuilder<PersonVOBuilder> {
	  public de.jro.example.business.PersonVO build() {
	    return new de.jro.example.business.PersonVO(id,name,age);
	  }
	}
	
src-gen/_de.jro.example.business.PersonVOBuilder.java_

	package de.jro.example.rest;
	
	import javax.validation.constraints.Min;
	import javax.validation.constraints.NotNull;
	
	@SuppressWarnings("all")
	public class PersonDTO {
	  @NotNull(message = "name must be set.")
	  private String name;
	  
	  @Min(value = 0)
	  private Integer age;
	  
	  public String getName() {
	    return this.name;
	  }
	  
	  public void setName(final String name) {
	    this.name = name;
	  }
	  
	  public Integer getAge() {
	    return this.age;
	  }
	  
	  public void setAge(final Integer age) {
	    this.age = age;
	  }
	}

src-gen/_de.jro.example.rest.PersonDTO.java_

	package de.jro.example.rest;
	
	import de.jro.example.rest.PersonDTO;
	
	@SuppressWarnings("all")
	public class PersonIdDTO extends PersonDTO {
	  private Long id;
	  
	  public Long getId() {
	    return this.id;
	  }
	  
	  public void setId(final Long id) {
	    this.id = id;
	  }
	}

src-gen/_de.jro.example.rest.PersonIdDTO.java_

	package de.jro.example.rest;
	
	
	@SuppressWarnings("all")
	public class GenericPersonIdDTOBuilder<B extends GenericPersonIdDTOBuilder<B>> {
	  protected String name;
	  protected Integer age;
	  protected Long id;
	  
	  @SuppressWarnings("unchecked")
	  public B name(String name) {
	    this.name = name;
	    return (B) this;
	  }
	  @SuppressWarnings("unchecked")
	  public B age(Integer age) {
	    this.age = age;
	    return (B) this;
	  }
	  @SuppressWarnings("unchecked")
	  public B id(Long id) {
	    this.id = id;
	    return (B) this;
	  }
	}

src-gen/_de.jro.example.rest.GenericPersonIdDTOBuilder.java_

	package de.jro.example.rest;
	
	
	@SuppressWarnings("all")
	public class PersonIdDTOBuilder extends de.jro.example.rest.GenericPersonIdDTOBuilder<PersonIdDTOBuilder> {
	  public de.jro.example.rest.PersonIdDTO build() {
	    de.jro.example.rest.PersonIdDTO obj = new de.jro.example.rest.PersonIdDTO();
	    obj.setName(name);
	    obj.setAge(age);
	    obj.setId(id);
	    return obj;
	  }
	}

src-gen/_de.jro.example.rest.PersonIdDTOBuilder.java_


	package de.jro.example.test.persistence;
	
	
	import org.mockito.Mockito;
	
	@SuppressWarnings("all")
	public class PersonEntityMocker extends de.jro.example.persistence.GenericPersonEntityBuilder<PersonEntityMocker> {
	  public de.jro.example.persistence.PersonEntity mock() {
	     de.jro.example.persistence.PersonEntity mockObj = Mockito.mock(de.jro.example.persistence.PersonEntity.class);
	     Mockito.when(mockObj.isDeleted()).thenReturn(deleted);
	     Mockito.when(mockObj.getId()).thenReturn(id);
	     Mockito.when(mockObj.getLastUpdateDate()).thenReturn(lastUpdateDate);
	     Mockito.when(mockObj.getName()).thenReturn(name);
	     Mockito.when(mockObj.getAge()).thenReturn(age);
	     return mockObj;
	  }
	  
	  public de.jro.example.persistence.PersonEntity spy() {
	     de.jro.example.persistence.PersonEntity spyObj = Mockito.spy(de.jro.example.persistence.PersonEntity.class);
	     Mockito.doReturn(deleted).when(spyObj).isDeleted();
	     Mockito.doReturn(id).when(spyObj).getId();
	     Mockito.doReturn(lastUpdateDate).when(spyObj).getLastUpdateDate();
	     Mockito.doReturn(name).when(spyObj).getName();
	     Mockito.doReturn(age).when(spyObj).getAge();
	     return spyObj;
	  }
	}

src-gen/_de.jro.example.test.persistence.PersonEntityMocker.java_


	package de.jro.example.test.business;
	
	
	import org.mockito.Mockito;
	
	@SuppressWarnings("all")
	public class PersonVOMocker extends de.jro.example.business.GenericPersonVOBuilder<PersonVOMocker> {
	  public de.jro.example.business.PersonVO mock() {
	     de.jro.example.business.PersonVO mockObj = Mockito.mock(de.jro.example.business.PersonVO.class);
	     Mockito.when(mockObj.getId()).thenReturn(id);
	     Mockito.when(mockObj.getName()).thenReturn(name);
	     Mockito.when(mockObj.getAge()).thenReturn(age);
	     return mockObj;
	  }
	  
	  public de.jro.example.business.PersonVO spy() {
	     de.jro.example.business.PersonVO spyObj = Mockito.spy(de.jro.example.business.PersonVO.class);
	     Mockito.doReturn(id).when(spyObj).getId();
	     Mockito.doReturn(name).when(spyObj).getName();
	     Mockito.doReturn(age).when(spyObj).getAge();
	     return spyObj;
	  }
	}

src-gen/_de.jro.example.test.business.PersonVOMocker.java_

	package de.jro.example.test.rest;
	
	
	import org.mockito.Mockito;
	
	@SuppressWarnings("all")
	public class PersonIdDTOMocker extends de.jro.example.rest.GenericPersonIdDTOBuilder<PersonIdDTOMocker> {
	  public de.jro.example.rest.PersonIdDTO mock() {
	     de.jro.example.rest.PersonIdDTO mockObj = Mockito.mock(de.jro.example.rest.PersonIdDTO.class);
	     Mockito.when(mockObj.getName()).thenReturn(name);
	     Mockito.when(mockObj.getAge()).thenReturn(age);
	     Mockito.when(mockObj.getId()).thenReturn(id);
	     return mockObj;
	  }
	  
	  public de.jro.example.rest.PersonIdDTO spy() {
	     de.jro.example.rest.PersonIdDTO spyObj = Mockito.spy(de.jro.example.rest.PersonIdDTO.class);
	     Mockito.doReturn(name).when(spyObj).getName();
	     Mockito.doReturn(age).when(spyObj).getAge();
	     Mockito.doReturn(id).when(spyObj).getId();
	     return spyObj;
	  }
	}
	
src-gen/_de.jro.example.test.rest.PersonIdDTOMocker.java_


That's it :-) Do you think boby could do more? We think the same, but we do not have endless time to develop everything by our own. You are gladly invited to contribute.

